#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$_dir" ]] && _dir=.
    if [[ -d "$_dir" ]]; then
        cde "$_dir" "$@"
        return 0
    fi
    return 1
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


