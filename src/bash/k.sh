#! /bin/cat

k () {
    (cd $1; shift; "$@")
}

kk () {
    (clear;
    cd $1; shift
    "$@")
}

kl () {
    kk "$@"
    lk
}

kv () {
    (cd $1; shift
    vim -p "$@"
    gsi)
}

kkk () {
    (clear;
    c $1; shift
    "$@")
}


