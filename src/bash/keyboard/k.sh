#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$*" ]] && c $_dir || (cd $_dir; k "$@")
}

# xx

kk () {
    (cd $1; shift
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

# xxx

kkk () {
    clear
    (c $1; shift
    "$@")
}


