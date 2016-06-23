#! cat

# x

r () {
    rm -vrf "$@"
}


# xx

rr () {
    rm -rf "$@"
}

# xxx

rrr () {
    sudo rm -rf "$@" 2> /dev/null
}

