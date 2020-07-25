#! /bin/cat


# _
# x
# _x
# xx

alias b=echo
alias bt="set -eu; source ~/bash/bashtrace.sh"

bu () {
    brew upgrade "$@"
}

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
