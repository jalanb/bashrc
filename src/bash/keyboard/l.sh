#! /bin/cat

l () {
    $LS_PROGRAM "$@"
}

ll () {
    ls -l  "$@"
}

lll () {
    ll -lahtr "$@"
}


