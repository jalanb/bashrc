#! /bin/cat


# _
# x

alias m=echo
# _x
# xx

md () {
    mkdir -p "$@" 2>/dev/null
}

mkd () {
    local __doc__='make a directory'
    local verbose_=1
    [[ $1 =~ -q ]] && shift && verbose_=
    if [[ -d "$1" ]]; then
        [[ $verbose_ ]] || return 0
        echo Directory existed "$@" >&2
        return 1
    fi
    md "$1"
    [[ -d "$1" ]]
}

mkcd () {
    local __doc__='make a directory and cd to it';
    mkd  -q "$1" || return 1
    cd "$1"
}

mvim () {
    local _mvim=/Applications/MacVim.app/Contents/bin/mvim 
    ([[ "$@" ]] && $_mvim --remote-tab "$@" || $_mvim --remote) > ~/log/mvim.log 2> ~/log/mvim.err
}

