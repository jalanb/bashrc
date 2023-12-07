#! /bin/cat


# _
# x
# _x
# xx

b () {
    bd ~
}

alias bt="set -eu; source ~/bash/bashtrace.sh"

bb () {
    l bbb
}

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

bbbb () {
    deactivate
    hash -d python python3 2>/dev/null
}

balck () {
    local __doc__="""Common typo"""
    black "$@"
}
