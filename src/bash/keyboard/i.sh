#! /usr/bin/env kat -n

. ~/bash/history.sh


# _
# x

I () {
    printf "%s" "$*"
}

# xx

inj () {
    ind ~/jalanb "$@"
}

init () {
    local __doc__="""LOok for __init__.sh here, there, or below and source it if found"""
    local _init=./__init__.sh
    [[ -f $_init ]] || _init=$1
    [[ -f $_init ]] || _init=bash/__init__.sh
    [[ -f $_init ]] || _init=src/bash/__init__.sh
    [[ -f $_init ]] && . $_init
}

