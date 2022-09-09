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
    local host_= remote_= options_="$@"
    if [[ $hosts_ ]]; then
        host_=${hosts_[0]}
        remote_=${hosts_[1]}
        options_=$(echo "$options_" | sed -e "s/$host_//")
    else
        remote_="$@"
    fi
<<<<<<< HEAD
    local pinged_=
    if [[ $options_ =~ -q ]]; then
        options_=$(echo "$@" | sed -e "s/$host_//" -e "s/-q//")
        pinged_=$(ping -c1 $options_ "$remote_" 2>/dev/null)
    else
        pinged_=$(ping -c1 $options_ "$remote_")
    fi
    local ping_result_=$?
    [[ $ping_result_ == 0 ]] || return $ping_result_
    [[ $pinged_ ]] || return 10
    echo $pinged_ | grep -q "Unreachable" && return 11
    echo $pinged_ | grep "([0-9]*[.][0-9.]*)" | sed -e "s/PING //" -e "s/ (/ -> /" -e "s/).*//" | grep --color ' [0-9.]*'
||||||| parent of e302d433 (Explicit is better than implicit.)
    local pinged_=
    if [[ $options_ =~ -q ]]; then
        options_=$(echo "$@" | sed -e "s/$host_//" -e "s/-q//")
        pinged_=$(ping -c1 $options_ "$remote_" 2>/dev/null)
    else
        pinged_=$(ping -c1 $options_ "$remote_")
    fi
    [[ $pinged_ ]] || return 1
    echo $_pinged | grep "([0-9]*[.][0-9.]*)" | sed -e "s/PING //" -e "s/ (/ -> /" -e "s/).*//" | grep ' [0-9.]*'
=======
    [[ $options_ =~ -t ]] || options_="-t1 $options_" 
    [[ $options_ =~ -c ]] || options_="-c1 $options_" 
    local quiet_=
    [[ $options_ =~ -q ]] && quiet_=1
    [[ $options_ =~ -q ]] && options=${options_/ -q/}
    local ping_="ping $options_ $remote_"
    local pinged_=$([[ $quiet_ ]] && $ping_ 2>/dev/null || $ping_)
    [[ $? == 0 ]] || return 1
    [[ $quiet_ == 1 ]] || echo $_pinged | grep "([0-9]*[.][0-9.]*)" | sed -e "s/PING //" -e "s/ (/ -> /" -e "s/).*//" | grep ' [0-9.]*'
>>>>>>> e302d433 (Explicit is better than implicit.)
    return 0
}

<<<<<<< HEAD
poss ()
{
    ssh $1 "hostname"
}
||||||| parent of e302d433 (Explicit is better than implicit.)
=======
pongable () {
    local remote_=$1
    pong -q -c1 -t1 $remote_
}

poss () {
    ssh $1 "hostname"
}

>>>>>>> e302d433 (Explicit is better than implicit.)
# xxxxx
# xxxxxx

online () {
    [[ "$@" ]] && show_online "$@" || online_all
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
    online_macs
    online_workers
}

pong_local () {
    pong -t1 $1.local
}

is_online () {
    pingable "$@" && show_pass $(pong -q "$@") || show_fail "$@"
}

pingable () { 
    quick_pong -q "$@" >/dev/null 2>&1 && return 0
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

online_mac () {
    local show_=green_line
    pongable $1 || show_=red_line
    $show_ $1
}

online_worker () {
    local show_=green_line
    pongable $1 || show_=red_line
    $show_ $1
}


online_macs () {
    online_mac book.local || return 1
    online_mac mac.local || return 2
    online_mac mini.local || return 3
    return 0
}

online_workers () {
    runnable worker || return 1
    online_worker git.wwts.com || return 2
    online_worker twkgit32.wwts.com || return 3
    local host_= project_= worker_=
    show_portals "twkwbe40:eopdev" "twkwbe41:eoptest" "twkwbe42:eopstage" "atlwbe43:eopbeta" "twkwbe43:eop"
    show_portals "twkwbe54:wmpdev" "twkwbe55:wmptest" "twkwbe56:wmpbeta" "twkwbe57:wmp"
    show_portals "twkwbe63:sosotest " "twkwbe64:sosobeta" "twkwbe65:soso"
}

show_portals () {
    for portal_ in "$@" ; do
        host_="${portal_/:*/}"
        project_="${portal_/*:/}"
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
