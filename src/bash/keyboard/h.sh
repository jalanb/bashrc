#! /usr/bin/env kat -n

. ~/bash/history.sh
. ~/bash/keyboard/v.sh


# _
# x

h () {
    local __doc__="tail history for half a screen"
    local _options=$(( $LINES / 2 ))
    history_tail "$@" $_options
}

# _x
# xx

alias HG=$(which hg 2>/dev/null) # With apologies, but don't really use it

h1 () {
    head -n 1 "$@"
}

hd () {
    vim_diff -o "$@"
}

alias hb=big_history_grep
alias hg=history_grep
alias hh="read_history | less -SNR"
alias hs=history_start

hl () {
    h "$@" | less
}

alias ht=history_tail_dateless
alias hv=history_vim
alias vh="history_vim -[ 1"
alias vhh="history_vim -[ 2"
alias hhv="history_vim -h"
alias hvv="vim -p ~/.bash_eternal_history ~/.big_eternal_history"


# xxx

hgt () {
    local __doc__="grep and tail history"
    hg "$@" | tail
}

ht1 () {
    history_tail 2 | head -n 1
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

read_history () {
    local history_command_="^history\(_[a-z-]*\)*" history_search_="^[Hh][Gghnt]" h_command="^h [0-9][0-9]*$"
    local history_log_="-e $history_command_ -e $history_search_ -e $h_command"
    local format_=
    if [[ $1 == -d ]]; then
        shift
        format_="%Y/%m/%d:%H:%M:%S "
    fi
    HISTTIMEFORMAT="$format_" history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v "$history_log_"
}

type_executable  () {
    type "$@" > /dev/null 2>&1
}

history_view () {
    local __doc__="view history"
    local _viewer=
    type_executable "$1" && _viewer="$1"
    [[ $_viewer ]] && shift || _viewer=tail
    local _options="-n $(( $LINES - 8 ))"
    [[ $1 == -n ]] && shift
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"
        shift
    fi
    read_history "$@" | $_viewer $_options
}

history_start () {
    history_view head "$@"
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
    [[ $1 =~ (-h|--help) ]] && ww hg && return 0
    local _back=
    [[ $1 =~ -B[0-9] ]] && _back=$1 && shift
    local _sought="$@"
    read_history -d | sed -es':^ *::' -e 's: *$::' | grep --color $_back "${_sought/ /.}"
}

history_tail_dateless () {
    history_tail "$@"
}

history_tail () {
    history_view tail "$@"
}

history_vim () {
    local __doc__="edit history"
    local tmp_=~/tmp/history.tmp historian_= 
    [[ $1 == -[ ]] && shift && historian_=$(history -p !-$1) && shift
    [[ $1 == -h ]] && shift && historian_=h
    [[ $historian_ ]] || historian_=read_history
    $historian_ "$@" > $tmp_
    local vim_suffix_=+
    if [[ -n $* ]]; then
        [[ "$@" =~ ^+ ]] && vim_suffix_="$@" || vim_suffix_=+/"$@"
    fi
    vim $tmp_ $vim_suffix_
}

hgf () {
    local sought_="$1"; shift
    local message_="$1"; shift
    (history | head -n 31 | grep --color $sought_ ) && show_fail "$message_"
}

close_kaufman () {
    hgf jeffkaufman "Close window"
}

hgg () {
    close_kaufman "$@"
}
