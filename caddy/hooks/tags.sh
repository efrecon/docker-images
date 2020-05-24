#!/usr/bin/env sh

newtags() {
    _flt=".*"
    while [ $# -gt 0 ]; do
        case "$1" in
            -f | --filter)
                _flt=$2; shift 2;;
            --filter=*)
                _flt="${1#*=}"; shift 1;;

            --)
                shift; break;;
            -*)
                echo "$1 unknown option!" >&2; return 1;;
            *)
                break;
        esac
    done

    [ "$#" -lt "2" ] && return 1

    _existing=$(mktemp)
    docker_tags --filter "$_flt" -- "$2" > "$_existing"
    docker_tags --filter "$_flt" -- "$1" | grep -F -x -v -f "$_existing"
    rm -f "$_existing"
}


# From: https://stackoverflow.com/a/37939589
version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}
