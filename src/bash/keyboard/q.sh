#! /bin/cat

. ~/jab/src/bash/queue.sh

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

qx () {
    local doc_="""Catch an edge case in terminal"""

    local doc__="""set -x writes to stderr, even after a subshell"""
    (set +x; "$@") 2>/dev/null
}

qq () {
    qx quietly "$@"
}

Qq () {
    qx Quietly "$@"
}

QQ () {
    qx QUIETLY "$@"
}

#
# xxx
# xxxx
# xxxxx
# xxxxxx
# xxxxxxx

quietly () {
    "$@" 2>/dev/null
}

Quietly () {
    "$@" 1>/dev/null
}

QUIETLY () {
    Quietly $(quietly "$@")
}
