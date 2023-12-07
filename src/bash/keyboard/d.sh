#! /bin/cat


# _
# x
# _x
# xx

alias d=echo

di () {
    icdiff "$@"
}

dn () {
    "$@" >/dev/null 2>/dev/null
}


ddg () {
    ddgr --ducky "$@"
}

ddu () {
    local query_=""
    open -n "https://duckduckgo.com/?q=$@"
}

dir () {
    local _where=.
    [[ -n "$@" ]] && _where="$@"
    say $(short_dir $_where)
}

dn1 () {
    "$@" > /dev/null
}
alias devnull=devnull1

ddf () {
    local __doc__="""where the function $1 came from"""
    ( shopt -s extdebug; declare -F "$1" )
}

dn2 () {
    "$@" 2> /dev/null
}

