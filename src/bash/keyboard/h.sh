#! /usr/bin/env kat -n

. ~/bash/history.sh

Welcome_to $BASH_SOURCE

# _
# x

h () {
    local __doc__="tail history"
    local _options="-n $(( $LINES / 2 ))"
    history_tail "$@" $_options
}

# _x
# xx

alias HG=$(which hg) # With apologies, but don't really use it

hg () {
    local __doc__="grep in history"
    history_parse | grep -v '^hg ' | grep --color "$@"
}

hh () {
    local __doc__="head history"
    local _options="-n $(( $LINES - 7 ))"
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"; shift
    fi
    h "$@" | head $_options
}

hl () {
    h "$@" | less
}

h1 () {
    ht 2 | head -n 1
}

ht () {
    local __doc__="tail history"
    local _options="-n $(( $LINES - 7 ))"
    if [[ $1 =~ ^[0-9] ]]; then
        _options="-n $1"; shift
    fi
    h "$@" | tail $_options
}

hv () {
    local __doc__="edit history"
    history_parse "$@" > ~/tmp/history.tmp
    local _vim_suffix=+
    if [[ -n $* ]]; then
        _vim_suffix=+/"$@"
        [[ "$@" =~ ^+ ]] && _vim_suffix="$@"
    fi
    vim ~/tmp/history.tmp $_vim_suffix
}

# xxx

hgt () {
    local __doc__="grep and tail history"
    hg "$@" | tail
}

Bye_from $BASH_SOURCE
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


# premature abbreviations

alias hn=history_view
alias hnh=history_head
alias hnt=history_tail

# history_xxxx+

export HISTORY_COUNTER=

history_parse () {
    HISTTIMEFORMAT= history "$@" | sed -e "s/^ *[0-9]*  //"  | grep -v "\<\(history\|[tg]h\)\>" 
}

history_count () {
    history_parse "$@" | cat -n
}

history_view () {
    local _history_viewer="cat -n"
    local _one="$1"
    if [[ -n $_one ]]; then
        [[ -e $1 ]] && _history_viewer=_one
        shift
    fi
    local __doc__="number history"
    local _count_options="-n $(( $LINES - 7 ))"
    if [[ $1 =~ ^[0-9] ]]; then
        _count_options="-n $1"; shift
    fi
    local _counter=tail
    [[ -n $HISTORY_COUNTER ]] && _counter=$HISTORY_COUNTER
    history_count "$@" | $_counter $_count_options | $_history_viewer
    [[ -n $HISTORY_COUNTER ]] && return
    export HISTORY_COUNTER=tail
}

history_head () {
    history_view head "$@"
}

history_tail () {
    history_view tail "$@"
}
