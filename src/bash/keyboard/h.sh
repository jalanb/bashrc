#! /usr/bin/env kat -n

. ~/bash/history.sh


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
    history_tail 2 | head -n 1
}

alias hg=history_grep
alias hh=history_head

hl () {
    h "$@" | less
}

alias ht=history_tail
alias hv=history_vim

# xxx

hgt () {
    local __doc__="grep and tail history"
    hg "$@" | tail
}

hgv () 
{ 
    local __doc__="edit history";
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@";
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@";
    fi
    h "$@" > ~/tmp/history.tmp
    vim ~/tmp/history.tmp $_vim_suffix;
    rr ~/tmp/history.tmp
}


# history_xxxx+

history_parse () {
    HISTTIMEFORMAT= history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v -e "^\<\(history\(_[a-z-]*\)*\|[Hh][Gghnt]\|h [0-9][0-9]*$\)\> "
}

history_view () {
    local __doc__="view history"
    local _viewer=
    whyp_executable "$1" && _viewer="$1"
    [[ $_viewer ]] && shift || _viewer=tail
    local _options="-n $(( $LINES - 7 ))"
    [[ $1 == -n ]] && shift
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"
        shift
    fi
    history_parse "$@" | $_viewer $_options
}

history_head () {
    history_view head "$@"
}

history_grep () {
    local __doc__="grep in history"
    [[ $1 =~ (-h|--help) ]] && ww hg && return 0
    local _back=
    [[ $1 =~ -B[0-9] ]] && _back=$1 && shift
    local _sought="$@"
    history_parse | sed -es':^ *::' -e 's: *$::' | grep --color $_back "${_sought/ /.}"
}

history_tail () {
    history_view tail "$@"
}

history_vim () {
    local __doc__="edit history"
    history_parse "$@" > ~/tmp/history.tmp
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@"
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@"
    fi
    vim ~/tmp/history.tmp $_vim_suffix
}

Bye_from $BASH_SOURCE
