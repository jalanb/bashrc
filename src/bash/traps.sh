#! /bin/cat

. ~/jab/src/bash/hub.sh
. ~/jab/src/bash/asserts.sh

trap_what () {
    _assert_directory ~/pym/what
    _assert_source ~/pym/what/what.sh
}

_trap_what () {
    [[ ! -d $WHAT && -d ~/pym/what ]] && WHAT=~/pym/what
    _trap_file $WHAT_SH
    source $WHAT_SH
}


_trap_python () {
    _assert_executable $(/usr/bin/env python)
    export PYTHON
}


_trap_jab () {
    [[ -d ~/jab ]] || return 1
<<<<<<< 4e0b7f57388e1a5466d0cbaec1de15a93b0a2d65
=======
    [[ ! -d ~/jab_LOCAL ]] && JAB_LOCAL=~/jab/local
>>>>>>> Prefer links to symbols
}

