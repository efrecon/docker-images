#!/bin/sh

ROOT_DIR=${ROOT_DIR:-"$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )"}

set -eu

# This script is a binenv wrapper that can be used to:
# 0. install binenv itself if it is not already present
# 1. install a binenv distribution
# 2. Get the list of the known binenv distributions
# 3. Get the known versions of a binenv distribution
# The script will automatically update the distribution list cache as soon as it
# is too old (15mins by default).

# XDG configuration directory (we need this because the directory is used by
# binenv itself.)
XDG_CONFIG=${XDG_CONFIG:-${HOME}/.config}

# Root directory where binenv installs its binaries. This should be the same
# directory as the one given to binenv install --bindir.
BINENV_BINDIR=${BINENV_BINDIR:-${HOME}/.binenv}

# Directory where binenv caches data (distribution list, etc.)
BINENV_CFGDIR=${BINENV_CFGDIR:-${XDG_CONFIG%/}/binenv}

# Location of the cached distribution list kept by binenv.
BINENV_LIST=${BINENV_LIST:-${BINENV_CFGDIR%/}/distributions.yaml}

# When the distribution list is older than this age, the script will
# automatically request binenv for a cache update.
BINENV_AGE=${BINENV_AGE:-300}

# Location of the binenv binary itself, the default is binenv as found in the
# $PATH.
BINENV_BIN=${BINENV_BIN:-binenv}

# Project and location at GitHub. You shouldn't have to change that really...
BINENV_GHPROJ=${BINENV_GHPROJ:-devops-works/binenv}
BINENV_ROOTURL=${BINENV_ROOTURL:-https://github.com/${BINENV_GHPROJ}}
BINENV_VERSION=${BINENV_VERSION:-latest}

# Set this to 1 for more verbosity.
BINENV_VERBOSE=${BINENV_VERBOSE:-0}

usage() {
  # This uses the comments behind the options to show the help. Not extremly
  # correct, but effective and simple.
  echo "$0 is a binenv wrapper with following options:" && \
    grep "[[:space:]].)\ #" "$0" |
    sed 's/#//' |
    sed -r 's/([a-z])\)/-\1/'
  exit "${1:-0}"
}

while getopts "a:b:vh-" opt; do
  case "$opt" in
    a) # Age of distribution list cache after which to renew (in seconds)
      BINENV_AGE=$OPTARG;;
    b) # Path to binenv
      BINENV_BIN=$OPTARG;;
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
  if [ "$BINENV_VERBOSE" = "1" ]; then
    printf %s\\n "$1" >&2
  fi
}

_error() {
  printf %s\\n "$1" >&2
  exit 1
}

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

_distributions() {
  if ! [ -f "$BINENV_LIST" ]; then
    "$BINENV_BIN" update --distributions
  fi

  if ! [ -f "$BINENV_LIST" ]; then
    _error "Cannot find distribution list cache"
  fi


  grep -E '^  [a-zA-Z0-9_-]+:' "$BINENV_LIST" |
    sed -E 's/^  ([a-zA-Z0-9_-]+):/\1/g' |
    sed 's/ /\n/g'
}

_versions() {
  "$BINENV_BIN" update "$1"
  "$BINENV_BIN" versions "$1" |
    sed -E 's/^[a-zA-Z0-9_-]+: //' |
    grep -vE '^#.*' |
    sed 's/ /\n/g' |
    sed 's/[^[:print:]]//g' |
    sed 's/\[[0-9]m//g' |
    grep -E '^[0-9]+\.[0-9]+\.[0-9]+$'
}

# Create the binenv hidden directory if it does not exist yet.
if ! [ -d "$BINENV_BINDIR" ]; then
  _verbose "Creating missing binenv directory $BINENV_BINDIR"
  mkdir -p "$BINENV_BINDIR"
fi

# Automatically install the binenv directory in a way that is much similar to
# the way binenv installs itself into the $BINENV_BINDIR directory.
if ! command -v "$BINENV_BIN" >/dev/null 2>&1; then
  if [ -f "${BINENV_BINDIR}/${BINENV_BIN}" ] && [ -x "${BINENV_BINDIR}/${BINENV_BIN}" ]; then
    # Just recapture the binenv from the BINENV_BIN directory into the PATH when
    # we have found an executable with the right name.
    export PATH=${BINENV_BINDIR}:$PATH
  else
    if [ -z "$BINENV_VERSION" ] || [ "$BINENV_VERSION" = "latest" ]; then
      # Discover the latest version from the HTML page (maybe should we use the
      # API, but this avoids rate-limiting).
      BINENV_VERSION=$(_download "${BINENV_ROOTURL}/releases"|grep "href=\"/${BINENV_GHPROJ}/releases/tag/v[0-9].[0-9]*.[0-9]*\"" | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}')
    fi
    _verbose "Installing binenv v. ${BINENV_VERSION#v*} into $BINENV_BINDIR"
    # Download and install binenv, and arrange for the shim to be created.
    _download "${BINENV_ROOTURL}/releases/download/v${BINENV_VERSION#v*}/binenv_linux_amd64" > "${BINENV_BINDIR}/${BINENV_BIN}"
    chmod a+x "${BINENV_BINDIR}/${BINENV_BIN}"
    export PATH=${BINENV_BINDIR}:$PATH
  fi
fi

# Create the shim if it does not exist.
if ! [ -x "${BINENV_BINDIR%/}/shim" ]; then
  _verbose "Creating missing shim under $BINENV_BINDIR"
  ln -s "$(command -v "$BINENV_BIN")" "${BINENV_BINDIR%/}/shim"
fi

# Update distribution cache when current file is too old or does not exit.
if [ -f "$BINENV_LIST" ]; then
  changed=$(stat -c %Y "$BINENV_LIST")
  now=$(date +%s)
  age=$(( now - changed ))
  if [ "$age" -gt "$BINENV_AGE" ]; then
    _verbose "Distribution cache info is $age s. old, renewing"
    "$BINENV_BIN" update --distributions
  else
    _verbose "Distribution cache info is only $age s. old, keeping"
  fi
else
  "$BINENV_BIN" update --distributions
fi

case "$1" in
  inst*)
    [ "$#" -lt "2" ] && _error "Need at least the name of a distribution"
    # Do all versions when empty
    if [ -z "${3:-}" ]; then
      for BINENV_VERSION in $(_versions "$2"); do
        "$BINENV_BIN" install "$2" "$BINENV_VERSION"
      done
    else
      "$BINENV_BIN" update "$2"
      "$BINENV_BIN" install "$2" "$3"
    fi
    ;;

  ver*)
    [ "$#" -lt "2" ] && _error "Need at least the name of a distribution"
    _versions "$2"
    ;;

  dist*)
    _distributions
    ;;

  h*)
    usage
    ;;

  *)
    _error "$1 is an unknown command, should be one of install, versions, distributions"
    ;;
esac
