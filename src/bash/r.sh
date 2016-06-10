#! cat

r () {
    rm -vrf "$@"
}


rr () {
    rm -rf "$@"
}

rrr () {
    sudo rm -rf "$@" 2> /dev/null
}

