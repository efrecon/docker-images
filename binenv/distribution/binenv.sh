#!/bin/sh

ROOT_DIR=${ROOT_DIR:-"$( cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P )"}

set -eu

BINENV_DISTRIBUTION_LIST=${BINENV_DISTRIBUTION_LIST:-https://raw.githubusercontent.com/devops-works/binenv/master/distributions/distributions.yaml}

XDG_CONFIG=${XDG_CONFIG:-${HOME}/.config}
BINENV_BINDIR=${BINENV_BINDIR:-${HOME}/.binenv}
BINENV_CFGDIR=${BINENV_CFGDIR:-${XDG_CONFIG%/}/binenv}
BINENV_LIST=${BINENV_LIST:-${BINENV_CFGDIR%/}/distributions.yaml}

BINENV_AGE=${BINENV_AGE:-300}

BINENV_BIN=${BINENV_BIN:-binenv}

BINENV_VERBOSE=${BINENV_VERBOSE:-0}

BINENV_THIS=$0

usage() {
  # This uses the comments behind the options to show the help. Not extremly
  # correct, but effective and simple.
  echo "$0 is a binenv wrapper with following options:" && \
    grep "[[:space:]].)\ #" "$BINENV_THIS" |
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
  [ "$BINENV_VERBOSE" = "1" ] && printf %s\\n "$1" >&2
}

_error() {
  printf %s\\n "$1" >&2
  exit 1
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

if ! [ -d "$BINENV_BINDIR" ]; then
  if command -v "$BINENV_BIN" >/dev/null 2>&1; then
    _verbose "Creating missing binenv environment under $BINENV_BINDIR"
    mkdir -p "$BINENV_BINDIR"
    ln -s "$(command -v "$BINENV_BIN")" "${BINENV_BINDIR%/}/shim"
  fi
fi

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
