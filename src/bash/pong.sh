#! /bin/cat


type show_pass >/dev/null 2>&1 || . ~/bash/crayons.sh

# set -e

# x
# xx
# xxx
# xxxx

pong () {
    local __doc__="""pong(""$@"")"""
    declare -a hosts_=($(ssh_host "$@"))
    local host_= remote_= options_=
    if [[ $hosts_ ]]; then
        host_=${hosts_[0]}
        remote_=${hosts_[1]}
        options_=$(echo "$@" | sed -e "s/$host_//")
    else
        remote_="$@"
    fi
    local pinged_=
    if [[ $options_ =~ -q ]]; then
        options_=$(echo "$@" | sed -e "s/$host_//" -e "s/-q//")
        pinged_=$(ping -c1 $options_ "$remote_" 2>/dev/null)
    else
        pinged_=$(ping -c1 $options_ "$remote_")
    fi
    [[ $pinged_ ]] || return 1
    echo $_pinged | grep "([0-9]*[.][0-9.]*)" | sed -e "s/PING //" -e "s/ (/ -> /" -e "s/).*//" | grep ' [0-9.]*'
    return 0
}

# xxxxx
# xxxxxx

online () {
    if [[ "$@" ]]; then
        show_online "$@"
    else 
        online_all
    fi
}

# xxxxxxx
# xxxxxxxx

ssh_host () {
    local __doc__="""Get a server name from the hostname in ~/.ssh/config ($@)"""
    local host_= remote_=
    while [[ $1 ]]; do
        if [[ $1 =~ ^- ]]; then
            shift
        elif [[ $1 =~ ^[0-9]*$ ]]; then
            shift
        else
            host_=$1
            remote_=$(ssh -G $host_ | grep ^hostname | cut -d' ' -f2)
            shift
        fi
    done
    [[ $host_ ]] || return 1
    [[ $remote_ ]] || return 1
    echo $host_ $remote_
    return 0
}

# xxxxxxxxx

# xxxxxxxxxx 

online_all () {
    show_online www.google.com
    local server_=
    for server_ in mac.local book.local mini.local; do
        show_online $server_
    done
    online_workers
}

pong_local () {
    pong -t1 $1.local
}

is_online () {
    pingable "$@" && show_pass $(pong -q "$@") || show_fail "$@"
}

pingable () { 
    quick_pong "$@" >/dev/null 2>&1 && return 0
    return 1
}

is_local_server () {
    [[ $1 =~ [.]local$ ]]
}

quick_pong () {
    # local __doc__="""quick_pong(""$@"")"""
    local _timeout="-t 3" _wait="-W 1" _remote="$1"
    # pingable && _timeout="-t 1"
    is_local_server $_remote && _timeout="-t 1"
    is_work_server $_remote && _timeout="-t 2"
    if pong $_timeout $_wait $_remote 2>&1 | grep -q -e usage -e illegal -e invalid; then
        pong ${_timeout/t/w} $_wait $_remote
    else
        # re-create stdout
        pong $_timeout $_wait $_remote
    fi
}

# xxxxxxxxxxx

show_online () {
    local line_end_=-l
    [[ $1 == --no-line ]] && line_end_=
    [[ $line_end_ ]] || shift
    if pingable "$@"; then
        local pong_out_=$(pong "$@")
        [[ $pong_out_ ]] || pong_out_="pingable $@"
        if [[ $line_end_ == -l ]]; then
            show_green_line $pong_out_
        else
            show_green $pong_out_
        fi
        return 0
    fi
    show_red $line_end_ "$@" offline
    return 1
}

show_worker () {
    local options_=
    while [[ $1 =~ ^[-] ]]; do
        options_="$options_ $1"
        shift
    done
    show_online $options_ $(worker $1)
}

online_workers () {
    runnable worker || return 1
    local host_= project_= worker_=
    for worker_ in "atlwbe43:eopbeta" "atlwbe49:dupontbeta" "twkwbe34:wmpstage" "twkwbe35:wmp" "twkwbe40:eopdev" "twkwbe41:eoptest" "twkwbe42:eopstage" "twkwbe43:eop" "twkwbe47:order" "twkwbe48:corteva" "twkwbe49:dupont" "twkwbe50:cortevatest" "twkwbe51:opp" "twkwbe52:oppdev" "twkwbe53:opptest" "twkwbe54:wmpstage" "twkwbe55:wmptest" "twkwbe56:wmpdev" "twkwbe57:wmpbeta" "twkwbe63:sosotest " "twkwbe64:sosobeta" "twkwbe65:soso" "twkwbe95:wmptest" "twkwbe96:wmpdev"; do
        host_="${worker_/:*/}"
        project_="${worker_/*:/}"
        # show_blue_line $project_:$host_
        show_worker --no-line $project_
        echo -n ", "
        show_worker $host_
    done
}

# xxxxxxxxxxxx

DNS_resfresh () {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
}
