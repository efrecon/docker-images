#!/usr/bin/env sh

newtags() {
    _src=$1
    _dst=$2
    _flt=.*
    [ "$#" -ge "3" ] && _flt=$3

    _existing=$(mktemp)
    docker_tags --filter "$3" -- "$2" > "$_existing"
    docker_tags --filter "$3" -- "$1" | grep -F -x -v -f "$_existing"
    rm -f "$_existing"
}