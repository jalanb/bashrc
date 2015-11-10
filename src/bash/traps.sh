#! /bin/bash

trap_github () {
    [[ -d $SRC ]] || SRC=$HOME/src
    [[ -d $GIT ]] || GIT=$SRC/git
    [[ -d $GITHUB ]] || GITHUB=$GIT/hub
}

_trap_what () {
    _assert_directory $GIT/what
    _assert_source $GIT/what/what.sh
}

_trap_what () {
    [[ ! -d $WHAT && -d $GITHUB/what ]] && WHAT=$GITHUB/what
    _trap_file $WHAT_SH
    source $WHAT_SH
}


_trap_python () {
    _assert_executable $(/usr/bin/env python)
    export PYTHON
}


_trap_jab () {
    [[ ! -d $JAB && -d $GITHUB/dotjab ]] && JAB=$GITHUB/dotjab
    [[ -d $JAB ]] || return 1
    [[ ! -d $JAB_LOCAL ]] && JAB_LOCAL=$JAB/local
    builtin cd $JAB
}

