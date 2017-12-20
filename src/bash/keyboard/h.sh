#! /usr/bin/env kat -n

. ~/bash/history.sh

Welcome_to $BASH_SOURCE

# _
# x

h () {
    history | tel "$@"
}

# _x
# xx


gh () {
    local __doc__="show stuff from history"
    _strip_history | grep --color "$@"
}

h1 () {
    th 2 | head -n1
}

hh () {
    _strip_history | head "$@"
}

hl () {
    _strip_history | less
}

th () {
    local _lines=$LINES
    if [[ $1 =~ [0-9] ]]; then
        _lines="$1"; shift
    fi
    local _sought=
    if [[ $1 == "?" ]]; then
        _sought="$1"; shift
        _strip_history | grep -A $_lines "$@"
    else
        _strip_history $_lines 
    fi
}

hv () {
    history | vim - +
}

vh () {
    local __doc__="edit stuff from history"
    if [[ -n $* ]]; then
        _strip_history > ~/tmp/fred
        local _search=+/"$@"
        [[ "$@" =~ ^+ ]] && _search="$@"
        vim ~/tmp/fred $_search
    else
        _strip_history > ~/tmp/fred
        vim ~/tmp/fred +
    fi
}

Bye_from $BASH_SOURCE
