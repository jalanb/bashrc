#! /bin/cat


# _
# x
# _x
# xx
#
x () {
    exit 1
}

xx () {
    (set -x; "$@") 2>&1 | grep -v -e crayons.sh -e prompt.sh
}

# xxx
#
xib () {
    bash -x ~/.bashrc
}


