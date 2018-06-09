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


alias HG=$(which hg) # With apologies, but don't really use it

hg () {
    local __doc__="grep in history"
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

ht () {
    local __doc__="tail history"
    local _options="-n $(( $LINES - 7 ))"
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"; shift
    fi
    _strip_history "$@" | tail $_options
}

hv () {
    history | vim - +
}

vh () {
    local __doc__="edit history"
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

# xxx

hgt () {
    local __doc__="grep and tail history"
    local _grep="$1"; shift
    th g $_grep "$@"
}

Bye_from $BASH_SOURCE
