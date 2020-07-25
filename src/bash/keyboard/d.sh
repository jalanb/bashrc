#! /bin/cat


# _
# x
# _x
# xx

alias d=echo

dn () {
    "$@" >/dev/null 2>/dev/null
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

