#! /bin/cat


type show_pass >/dev/null 2>&1 || . ~/bash/crayons.sh

# set -e

# xxxx

pong () {
    local ___doc__="""pong(""$@"")"""
    declare -a _hosts=($(ssh_host "$@"))
    local _host= _remote= _options=
    if [[ $_hosts ]]; then
        _host=${_hosts[0]}
        _remote=${_hosts[1]}
        _options=$(echo "$@" | sed -e "s/$_host//")
    else
        _remote="$@"
    fi
    local _pinged=$(ping -c1 $_options "$_remote")
    [[ $_pinged ]] || return 1
    echo $_pinged | grep "([0-9]*[.][0-9.]*)" | sed -e "s/PING //" -e "s/ (/ -> /" -e "s/).*//" | grep ' [0-9.]*'
    return 0
}

# xxxxxx

online () {
    if [[ "$@" ]]; then
        is_online "$@"
    else 
        online_all
    fi
}

# xxxxxxxx

ssh_host () {
    local __doc__="""Get a server name from the hostname in ~/.ssh/config ($@)"""
    local _host= _remmote=
    while [[ $1 ]]; do
        if [[ $1 =~ ^- ]]; then
            shift
        elif [[ $1 =~ ^[0-9]*$ ]]; then
            shift
        else
            _host=$1
            _remmote=$(ssh -G $_host | grep ^hostname | cut -d' ' -f2)
            shift
        fi
    done
    [[ $_host ]] || return 1
    [[ $_remmote ]] || return 1
    echo $_host $_remmote
    return 0
}

pingable () {
    is_online "$@" >/dev/null 2>&1 && return 0
    return 1
}

# xxxxxxxxx

is_online () {
    if quick_pong "$@" > ~/fd1 2> ~/fd2; then
        show_pass $(pong "$@")
        return 0
    else
        show_fail "$@" offline
        return 1
    fi
}

# xxxxxxxxxx

online_all () {
    is_online www.google.com
    if runnable worker; then
        is_online $(worker bots)
        is_online $(worker git)
        is_online $(worker wmp)
        is_online $(worker eop)
        is_online $(worker soso)
        is_online $(worker corteva)
        is_online $(worker eopdev)
    fi
    is_online mac.local
    is_online book.local
    is_online mini.local
}

pong_local () {
    pong -t1 $1.local
}

quick_pong () {
    local ___doc__="""quick_pong(""$@"")"""
    local _timeout="-t 3" _wait="-W 1" _remote="$1"
    is_local_server && _timeout="-t 1"
    is_work_server $_remote && _timeout="-t 2"
    if pong $_timeout $_wait $_remote 2>&1 | grep -q -e usage -e illegal -e invalid; then
        pong ${_timeout/t/w} $_wait $_remote
    else
        # make sure we return correctly
        pong $_timeout $_wait $_remote
    fi
}

