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
    local command_=. file_=~/bash/keyboard/$1.sh command_too_=
    if [[ $1 =~ -[bv.] ]]; then
        [[ $1 == -b ]] && command_=bat
        [[ $1 == -v ]] && command_=vim && command_too_="."
        shift
        file_=~/bash/keyboard/$1.sh
    fi
    $command_ $file_
    [[ $command_too_ ]] && $command_too_ $file_
}

kpj () {
    rsync -a -e "ssh -i $HOME/.ssh/id_jab" "$@"
}

