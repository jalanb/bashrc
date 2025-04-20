#! /bin/cat


# _
# x
# _x
# xx

b () {
    bd ~
}

alias bt="set -eu; source ~/bash/bashtrace.sh"

bd () {
    cd $1
    clear
    l
}

bk () {
    local __doc__="""Mature abbreviation"""
    [[ $1 ]] && black "$@" || black .
}

bu () {
    brew upgrade "$@"
}

alias bfd=fdb

bub () {
    brew update
}

bug () {
    GIT= bu git
}

bup () {
    bu python
}

but () {
    bu tig
}

balck () {
    local __doc__="""Common typo"""
    black "$@"
}
