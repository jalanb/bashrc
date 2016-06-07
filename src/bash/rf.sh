#! /bin/cat

_re_source () {
    SRC_BASH=$(dirname $(readlink -f $BASH_SOURCE)) && export SRC_BASH  # ; echo "SRC_BASH = $SRC_BASH"
    SRC=$(dirname $SRC_BASH) && export SRC # ; echo "SRC = $SRC"
    SRC_PYTHON=$SRC/python && export SRC_PYTHON # ; echo "SRC_PYTHON = $SRC_PYTHON"
}

# x

# xx

rd () {
    rf -d "$@"
}

rf () {
    $SRC_PYTHON/rf.py "$@"
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

rfp () {
    rf -qpr
}

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
    local directory_here=$(basename "$(pwd)")
    cd ..
    /bin/rm -rf "$directory_here"
}
