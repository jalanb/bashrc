#! /bin/bash

SRC_BASH=$(dirname $BASH_SOURCE)
SRC=$(dirname $SRC_BASH)
SRC_PYTHON=$SRC/python

RF_DOT_PY=$SRC_PYTHON/rf.py
RT_DOT_PY=$SRC_PYTHON/remove_tarball.py

# x

r () {
    rm -vrf "$@"
}

# xx

rd () {
    rf -d "$@"
}

rf () {
    ${PYTHON:-python2} $RF_DOT_PY "$@"
}

rr () {
    rf -r "$@"
}

rq () {
    rm -rf "$@"
}

rt () {
    $(${PYTHON:-python2} $RT_DOT_PY "$@")
}

ry () {
    rf -qpr
}

# xxx

rfq () {
    rf -q "$@"
}

rrq () {
    sudo rm -rf "$@"
}

rq. () {
    /bin/rm -rf ./*
}

rqa () {
    /bin/rm -rf ./* ./.* 2>&1 | grep -v 'cannot remove directory'
}

# xxxx

rq.. () {
    local directory_here=$(basename "$(pwd)")
    cd ..
    /bin/rm -rf "$directory_here"
}
