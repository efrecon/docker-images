#!/usr/bin/env sh

newtags() {
    _flt=".*"
    _verbose=0
    while [ $# -gt 0 ]; do
        case "$1" in
            -f | --filter)
                _flt=$2; shift 2;;
            --filter=*)
                _flt="${1#*=}"; shift 1;;

            -v | --verbose)
                _verbose=1; shift;;

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
    if [ "$_verbose" = "1" ]; then
        echo "Collecting relevant tags for $2" >&2
        docker_tags --filter "$_flt" --verbose -- "$2" > "$_existing"
        echo "Diffing aginst relevant tags for $1" >&2
        docker_tags --filter "$_flt" --verbose -- "$1" | grep -F -x -v -f "$_existing"
    else
        docker_tags --filter "$_flt" -- "$2" > "$_existing"
        docker_tags --filter "$_flt" -- "$1" | grep -F -x -v -f "$_existing"
    fi
    rm -f "$_existing"
}


# From: https://stackoverflow.com/a/37939589
version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}
