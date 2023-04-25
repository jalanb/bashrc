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
    qq gr "$@"
}

qx () {
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
    "$@" >/dev/null
}

QUIETLY () {
    quietly "$@" >/dev/null
}
