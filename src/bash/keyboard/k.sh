#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$_dir" ]] && _dir=.
    [[ -d "$_dir" ]] || return 1
    cd $_dir; 
    "$@"
}

# xx

kk () {
    clear
    k "$@" && ranger
}

kl () {
    kk "$@"
    l
}

kv () {
    (k $1 || return 1
    shift
    vim -p "$@" && gsi)
    return 0
}

# xxx

kkk () {
    :  # Name reserved
}


