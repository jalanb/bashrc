#! /bin/cat

Welcome_to $BASH_SOURCE

_re_source () {
    SRC_BASH=$(realdir $BASH_SOURCE) && export SRC_BASH  # ; echo "SRC_BASH = $SRC_BASH"
    BASH_DIR=$(dirname_ $SRC_BASH) && export BASH_DIR # ; echo "BASH_DIR = $BASH_DIR"
}

# x

# xx

rd () {
    rf -d "$@"
}

rf () {
    python ~/jab/src/python/rf.py "$@"
}

rq () {
    rm -ri "$@"
}

rt () {
    r -q "$@"
}

ry () {
    rf -qpr
}

# xxx

rfq () {
    rf -q "$@"
}

rr. () {
    /bin/rm -rf ./*
}

rra () {
    /bin/rm -rf ./* ./.* 2>&1 | grep -v 'cannot remove directory'
}

# xxxx

rr.. () {
    local directory_here=$(basename_ "$(pwd)")
    cd ..
    /bin/rm -rf "$directory_here"
}

Bye_from $BASH_SOURCE
