#! /bin/cat

# x

k () {
    local _dir="$1"; shift
    [[ -z "$_dir" ]] && _dir=.
    if [[ -d "$_dir" ]]; then
        (${XKCD:-cd} $_dir; 
        "$@")
    fi
}

# xx

kk () {
    clear
    k "$@"
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
    :  # Name reserved
}


