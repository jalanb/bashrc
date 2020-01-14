#! /bin/cat

. ~/bash/welcome.sh

Welcome_to $BASH_SOURCE

# x
# xx

same_dir () {
    [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

Bye_from $BASH_SOURCE
