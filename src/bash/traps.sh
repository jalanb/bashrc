#! /bin/cat

. ~/jab/jab/src/bash/hub.sh
. ~/jab/jab/src/bash/asserts.sh

trap_what () {
    _assert_directory $HUB/what
    _assert_source $HUB/what/what.sh
}

_trap_what () {
    [[ ! -d $WHAT && -d $HUB/what ]] && WHAT=$HUB/what
    _trap_file $WHAT_SH
    source $WHAT_SH
}


_trap_python () {
    _assert_executable $(/usr/bin/env python)
    export PYTHON
}


_trap_jab () {
    [[ ! -d ~/jab/jab && -d $HUB/jab ]] && JAB=$HUB/jab
    [[ -d ~/jab/jab ]] || return 1
    [[ ! -d ~/jab/jab_LOCAL ]] && JAB_LOCAL=~/jab/jab/local
}

