#! /usr/bin/env bat -l bash

. ~/bash/queue.sh
. ~/bash/quietly.sh

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

