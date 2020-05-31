#! /bin/cat



# x
# _
# xx

zm () {
    du -cms "$1" | sort -n | sed -e "s/\t/    /" -e "s/    / Mb /g"
}

zz () {
    du -sh "$*"
}

# _x
# _xx
# xxx

# . ~/jab/src/bash/zoo.sh

zzz () {
    df -h
}

Bye_from $BASH_SOURCE
