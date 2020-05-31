#! /bin/cat

. ~/bash/welcome.sh


# x
# xx

same_dir () {
    [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

