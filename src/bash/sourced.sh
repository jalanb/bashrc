#! /usr/bin/env head -n 3

# This script is intended to be sourced, not run

if [[ $FUNCNAME != source ]]; then
    _wat_shell=sh
    [[ $$ == $BASHPID ]] && _wat_shell=bash
    echo
    echo "This file should be run as "
    echo "    $ source $0"
    echo "or"
    echo "    $ . $0"
    echo "It should NOT be run as"
    echo "    $ $_wat_shell $0"
    echo
else
    echo :-)
fi
