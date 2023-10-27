#! /usr/bin/env kat -n

. ~/bash/history.sh


# _
# x
#
I () {
    printf "%s" "$*"
}

# xx
#
IP () {
    local _break=yes
    if [[ $1 == all ]]; then
        _break=no
    fi
    for number in 10 172 193 192 100
    do
        if ~/jab/bin/mifconfig $number; then
            if [[ $_break == yes ]]; then
                break
            fi
        fi
    done
}

# xxx
#
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

