#! /bin/cat


# _
# x
# _x
# xx

alias d=echo

ddf () {
    local __doc__="""where the arg came from"""
    ( shopt -s extdebug; declare -F "$1" )
}

