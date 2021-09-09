#!/bin/sh

# This script will generate YAML templates for the automatic creation of Docker
# images based on the tools (distributions) that are known to binenv. The script
# will not override any existing YAML workflow, neither will generate a workflow
# for Docker image generation when the target project (at GitHub) already has a
# Dockerfile (thus probably has a more "intelligent" Docker image than the one
# that this would produce.)

ROOT_DIR=${ROOT_DIR:-"$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )"}

set -eu

# URL to binenv distribution list in YAML format.
BINENV_DISTRIBUTION_LIST=${BINENV_DISTRIBUTION_LIST:-https://raw.githubusercontent.com/devops-works/binenv/master/distributions/distributions.yaml}

# Template to use for generating the GH workflow description that will itself
# generate a Docker image for the project. In that template, %DISTRIBUTION% will
# automatically be replaced by the name of the tool (known as a distribution to
# binenv).
BINENV_TEMPLATE=${BINENV_TEMPLATE:-${ROOT_DIR}/binenv.tpl}

# Destination directory for workflow templates.
BINENV_DESTINATION=${BINENV_DESTINATION:-$ROOT_DIR}

# Set this to 1 for more verbosity (or use the -v option).
BINENV_VERBOSE=${BINENV_VERBOSE:-0}

usage() {
  # This uses the comments behind the options to show the help. Not extremly
  # correct, but effective and simple.
  echo "$0 is a binenv wrapper with following options:" && \
    grep "[[:space:]].)\ #" "$BINENV_THIS" |
    sed 's/#//' |
    sed -r 's/([a-z])\)/-\1/'
  exit "${1:-0}"
}

while getopts "t:vh-" opt; do
  case "$opt" in
    t) # Path to YAML template
      BINENV_TEMPLATE=$OPTARG;;
    v) # Turn on verbosity
      BINENV_VERBOSE=1;;
    h)
      usage;;
    -)
      break;;
    *)
      usage 1;;
  esac
done
shift $((OPTIND-1))


_verbose() {
  [ "$BINENV_VERBOSE" = "1" ] && printf %s\\n "$1" >&2
}

_error() {
  printf %s\\n "$1" >&2
  exit 1
}

# Download a URL and print its content on stdout, prefers curl, can also use
# wget.
_download() {
  _verbose "Downloading $1"
  if command -v curl >&2 >/dev/null; then
    curl -sSL "$1"
  elif command -v wget >&2 >/dev/null; then
    wget -q -O - "$1"
  else
    _error "Can neither find curl, nor wget for downloading"
  fi
}

# Download the list of distributions known to binenv
DISTRO_LIST=$(mktemp)
_download "$BINENV_DISTRIBUTION_LIST" > "$DISTRO_LIST"

_distributions() {
  grep -E '^  [a-zA-Z0-9_-]+:' "$DISTRO_LIST" |
    sed -E 's/^  ([a-zA-Z0-9_-]+):/\1/g' |
    sed 's/ /\n/g'
}

# For all distributions, i.e. tools, generate a GH workflow for Docker image
# creation if it does not already exist and the remote project doesn't already
# have a Dockerfile under its root (a heuristic that works much better than one
# would think).
for DISTRIBUTION in $(_distributions); do
  tgt=${BINENV_DESTINATION%/}/${DISTRIBUTION}.yml
  if [ -f "$tgt" ]; then
    _verbose "Skipping $tgt, exists already"
  else
    # Extract the GitHub API URL for that distribution. We will use this to
    # select projects at GitHub only, and then isolate the name of the target
    # project itself.
    GHAPI=$(  sed -E "/^  ${DISTRIBUTION}:/,/^$/!d" "$DISTRO_LIST" |
              grep -E '^      url:' |
              grep "api.github.com" |
              sed -E 's/^      url: (.*)/\1/' )
    if [ -n "$GHAPI" ]; then
      # Isolate name of project at GitHub.
      GHPROJ=$( printf %s\\n "$GHAPI" | sed -E -e 's~^https://api.github.com/repos/~~' -e 's~/releases$~~')
      # Try downloading a Dockerfile under the master/main branches. When none
      # exists, create a workflow.
      if _download "https://raw.githubusercontent.com/${GHPROJ}/master/Dockerfile" > /dev/null \
        || _download "https://raw.githubusercontent.com/${GHPROJ}/main/Dockerfile" > /dev/null; then
        _verbose "Project $GHPROJ has already a Dockerfile, skipping"
      else
        _verbose "Generating $tgt"
        sed -e "s/%DISTRIBUTION%/${DISTRIBUTION}/g" "$BINENV_TEMPLATE" > "$tgt"
      fi
    else
      _verbose "Generating $tgt"
      sed -e "s/%DISTRIBUTION%/${DISTRIBUTION}/g" "$BINENV_TEMPLATE" > "$tgt"
    fi
  fi
done

# Remove distribution list cache.
rm -f "$DISTRO_LIST"