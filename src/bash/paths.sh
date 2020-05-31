#! /bin/cat



# x
# xx

same_dir () {
    [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

