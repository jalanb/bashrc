#! /bin/cat

k () {
    if [[ -d "$1" ]]; then
        local _dir="$1"
        shift
        if [[ -z "$*" ]]; then
            c $_dir
        else
            (cd $_dir
            k "$@")
        fi
    else
        "$@"
    fi
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


