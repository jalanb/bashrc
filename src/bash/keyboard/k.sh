#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$*" ]] && _dir=.
    if [[ -d "$_dir" ]]; then
        (c $_dir; 
        "$@")
    fi
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


