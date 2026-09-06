#! /usr/bin/env cat

. ~/bash/history.sh
. ~/bash/keyboard/v.sh


# _
# x

h () {
    local __doc__="tail history for half a screen"
    local lines_=$(( $LINES / 2 ))
    history_view tail $lines_ "$@"
}

# _x
# xx

h1 () {
    head -n 1 "$@"
}

hd () {
    vim_diff -o "$@"
}

hb () {
    big_history_grep "$@"
}

hg () {
    history_grep "$@"
}

hl () {
    history_read | less -SNR
}

hh () {
    history_view head "$@"
}


hl () {
    h "$@" | less
}

ht () {
    history_view tail "$@"
}

hv () {
    history_vim
}

vh () {
    history_vim '-[' 1
}

vhh () {
    history_vim '-[' 2
}

hd1 () {
    head -n 1 "$@"
}

hed () {
    SCREEN=$(screen_height)
    SCREEN=${LINES:-$(screen_height)}
    HALF_SCREEN=`expr $SCREEN / 2`
    HEADLINES=${HEADLINES:-$HALF_SCREEN}
    head -n ${1:-$HEADLINES} "$@"
}

hub () {
    local directory_=~/hub
    local remote_=
    [[ $( clipout ) =~ http.*git ]] && remote_=$( clipout )
    [[ $1 =~ http.*git ]] && remote_="$1" && shift
    local destination_=
    if [[ -n "$@" ]]; then
        if cde_ok ~/hub "$@"; then
            directory_=$(cde_first ~/hub "$@")
        fi
    fi
    if [[ $remote_ =~ http ]]; then
        [[ -d $directory_ ]] && cd $directory_
        directory_=$(clone -n $remote_)
    fi
    [[ -d $directory_ ]] && cde $directory_
    [[ $(rlf $directory_) == $(rlf ~/hub) ]] && return 0
    cde $directory_
}

hhv () {
    history_vim -h
}

hvv () {
    vim -p ~/.bash_eternal_history ~/.big_eternal_history
}



# xxx

hd1 () {
    head -n 1 "$@"
}

hed () {
    SCREEN=$(screen_height)
    SCREEN=${LINES:-$(screen_height)}
    HALF_SCREEN=`expr $SCREEN / 2`
    HEADLINES=${HEADLINES:-$HALF_SCREEN}
    head -n ${1:-$HEADLINES} "$@"
}

hgf () {
    local sought_="$1"; shift
    local message_="$1"; shift
    (history | head -n 31 | grep --color $sought_ ) && show_fail "$message_"
}

hgt () {
    local __doc__="grep and tail history"
    hg "$@" | tail
}

htt () {
    history_view tail 2 | head -n 2
}

# xxxx

hilp () {
    quietly "$@" --help || "$@" -h
}

# xxxxxxxxx

hash_bang () {
    local head_=$(h1 "$1")
    echo "$head_" | grep -q "^#!" || return 1
    echo "$head_" | grep --color -e python -e bash && return 0
    echo "$head_" | grep --color 'env [^ ]*' && return 0
    echo "$head_" | grep --color '[!] [^ ]*' && return 0
    return 1
}

# history_xxxx+

type_executable  () {
    type "$@" > /dev/null 2>&1
}

big_history_grep () {
    local number_=32
    if [[ $1 == "-n" && $2 =~ ^[0-9]*$ ]]; then
        number_=$2
        shift 2
    fi
    grep "$@" ~/.b*history | tail -n $number_ | sed -e "s,[^:]*:,," | grep --color "$@"
}

history_grep () {
    local __doc__="grep in history"
    [[ $1 =~ (-h|--help) ]] && ww history_grep && return 0
    local back_= date_=
    [[ $1 =~ -B[0-9] ]] && back_=$1 && shift
    [[ $1 =~ -d ]] && date_=--date && shift
    local sought_="$@"
    history_read $date_ | sed -es':^ *::' -e 's: *$::' | grep --color $back_ "${sought_/ /.}"
}

history_read () {
    local history_command_="^history\(_[a-z-]*\)*" history_search_="^[Hh][Gghnt]" h_command="^h [0-9][0-9]*$"
    local history_log_="-e $history_command_ -e $history_search_ -e $h_command"
    local format_=
    if [[ $1 =~ [-]+d[ate]* ]]; then
        shift
        format_="%Y/%m/%d:%H:%M:%S "
    fi
    HISTTIMEFORMAT="$format_" history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v "$history_log_"
}

history_view () {
    local __doc__="view history"
    local viewer_=
    type_executable "$1" && viewer_="$1"
    [[ $viewer_ ]] && shift || viewer_="tail"
    local lines_="-n $(( LINES - 8 ))"
    if [[ $1 =~ ^[0-9] ]]; then
        lines_="-n $1"
        shift
    elif [[ $1 =~ ^- ]]; then
        if [[ $1 == -n ]]; then
            shift
            lines_="-n $1"
            shift
        elif [[ $1 =~ ^-[0-9] ]]; then
            lines_="-n ${1#-}"
            shift
        fi
    fi
    history_read "$@" | "$viewer_" "$lines_"
}

history_vim () {
    local __doc__="edit history"
    local tmp_=~/tmp/history.tmp historian_= 
    [[ $1 == -[ ]] && shift && historian_="history -p !-$1" && shift
    [[ $1 == -h ]] && shift && historian_=h
    [[ $historian_ ]] || historian_=history_read
    $historian_ "$@" > $tmp_
    local vim_suffix_=+
    if [[ -n $* ]]; then
        [[ "$@" =~ ^+ ]] && vim_suffix_="$@" || vim_suffix_=+/"$@"
    fi
    vim $tmp_ $vim_suffix_
}

close_kaufman () {
    hgf jeffkaufman "Close window"
}
