#!/bin/sh

usage() {
    echo "usage: $0 -s seconds, number of seconds to sleep (default: 1)"
    echo "          -n iterations, Number of times to repeat (default: forever)"
}


SLEEP=1
ITERATIONS=-1
while getopts "s:n:" opt; do
    case $opt in
        s)
            SLEEP="$OPTARG"
            ;;
        n)
            ITERATIONS="$OPTARG"
            ;;
        \?)
            set +x
            echo "Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            set +x
            echo "Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done
shift $(expr $OPTIND - 1)

t=$ITERATIONS
while [ $t -gt 0 -o $ITERATIONS -lt 0 ]; do
    sleep $SLEEP
    t=$(expr $t - 1)
    $@
done
