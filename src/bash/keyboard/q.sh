#! /usr/bin/env bat -l bash

. ~/jab/src/bash/queue.sh
. ~/jab/src/bash/quietly.sh

# quit may be defined in queue.sh
# x
# _

q () {
    quit
}

alias Q="exit 0"

# xx

qg () {
    qq g "$@"
}

qr () {
    qq gr "$@"
}

