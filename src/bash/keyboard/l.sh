#! /bin/cat

# x


l () {
    $LS_PROGRAM "$@"
}

# xx

ll () {
    ls -l  "$@"
}

# xxx

lll () {
    ll -lahtr "$@"
}


