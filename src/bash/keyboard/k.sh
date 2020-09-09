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

ky () {
    shift_dir "$@" && shift
    dir=${dir:-~/jab/src/python}
    cde $dir "$@"
    y .
}

# xxx

kad () {
    head -n1 | grep -q '#!' || return;
    kat -f '{$' -l '^}' "$@" | bat -l bash
}

key () {
    . ~/bash/keyboard/$1.sh
}

kkk () {
    :  # Name reserved
}

kpj () {
    rsync -a -e "ssh -i $HOME/.ssh/id_jab" "$@"
}

