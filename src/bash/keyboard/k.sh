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
    local command_=whyp_source file_=~/bash/keyboard/$1.sh
    [[ -f "$file_" ]] || return 1
    shift
    if [[ $1 =~ -[blsv] ]]; then
        if [[ $1 == -b ]]; then command_=bat
        elif [[ $1 == -l ]]; then command_="ls -l"
        elif [[ $1 == -s ]]; then command_=whyp_source
        elif [[ $1 == -v ]]; then command_="vim -p"
        fi
        shift
    fi
    [[ "$command_" ]] || return 2
    $command_ $file_
    [[ $command_ == "vim -p" ]] && whyp_source $file_
}
