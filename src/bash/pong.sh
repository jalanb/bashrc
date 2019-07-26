#! /bin/cat

Welcome_to $BASH_SOURCE

. ~/bash/coloured.sh

# set -e


pong () {
    local _remote=$(ssh_host $1)
    ping -c1 "$@" | grep "([0-9]*[.][0-9.]*)" | sed -e "s/PING //" -e "s/ (/ -> /" -e "s/).*//" | g ' [0-9.]*'
}

online () {
    if [[ "$@" ]]; then
        is_online "$@"
    else 
        online_all
    fi
}

is_online () {
    if quick_pong "$@" > ~/bash/fd/1 2> ~/bash/fd/2; then
        show_pass $(pong "$@")
        return 0
    else
        show_fail "$@" offline
        return 1
    fi
}

pingable () {
    is_online "$@" >/dev/null 2>&1 && return 0
    return 1
}

pong_local () {
    pong -t1 $1.local
}

quick_pong () {
    local _timeout="-w 2"
    [[ $_remote =~ $(worker)$ ]] && _timeout="-w 3"
    [[ $_remote =~ [.]local$ ]] && _timeout="-w 1"
    if pong $_timeout -W 1 $_remote 2>&1 | grep -q -e usage -e illegal -e invalid; then
        # looks like OS X
        pong ${_timeout/w/t} -W 1 $_remote
    else
        # make sure we return correctly
        pong $_timeout -W 1 $_remote
    fi
}

Bye_from $BASH_SOURCE
