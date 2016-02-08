#! /bin/cat

_re_source () {
    SRC_BASH=$(dirname $(readlink -f $BASH_SOURCE)) && export SRC_BASH  # ; echo "SRC_BASH = $SRC_BASH"
    SRC=$(dirname $SRC_BASH) && export SRC # ; echo "SRC = $SRC"
    SRC_PYTHON=$SRC/python && export SRC_PYTHON # ; echo "SRC_PYTHON = $SRC_PYTHON"
    RF_DOT_PY=$SRC_PYTHON/rf.py && export RF_DOT_PY # ; echo "RF_DOT_PY = $RF_DOT_PY"
    RT_DOT_PY=$SRC_PYTHON/remove_tarball.py && export RT_DOT_PY # ; echo "RT_DOT_PY = $RT_DOT_PY"
}

# x

r () {
    rm -vrf "$@"
}

# xx

rd () {
    rf -d "$@"
}

rf () {
    (_re_source; ${PYTHON:-python2.7} $RF_DOT_PY "$@")
}

rr () {
    rf -r "$@"
}

rq () {
    rm -rf "$@"
}

rt () {
    (_re_source; $(${PYTHON:-python2.7} $RT_DOT_PY "$@"))
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
