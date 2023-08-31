#! /bin/cat

# x

k () {
    # cd to the directory $1 and run args
    [[ $2 ]] || return 2
    local dir_="$1"
    shift
    [[ "$dir_" ]] || return 3
    [[ -d "$dir_" ]] || return 5
    cd $dir_
    "$@"
}

# xx

kk () {
    (
        k "$@"
    )
}

kl () {
    # cd to the directory $1 and run ls
    k "$1" l
}

kr () {
    keys_read
}

kv () {
    vim_keys "$@"
}

kw () {
    write_keys
}

# xxx

has_bash () {
    [[ $1 =~ [.]sh$ ]] && return 0
    head -n1 "$1" | grep -q '#!.*bash' && return 0
    return 1
}

kad () {
    has_bash "$1" || return 1
    kat -f '{$' -l '^}' "$@" | bat -l bash
}

key () {
    local command_=whyp_source file_= path_= option_=
    if [[ $1 =~ [-] ]]; then
        option_=$1
        path_="$HOME/bash/keyboard/$2.sh"
    else
        path_="$HOME/bash/keyboard/$1.sh"
        [[ $2 =~ [-] ]] && option_=$2
    fi
    shift 2
    [[ $option_ ]] || $option_="-s"
    [[ -f "$path_" ]] || return 1
    shift
    local vim_command_="vim +1 "
    if [[ $option_ =~ -[blsv] ]]; then
        if [[ $option_ == -b ]]; then command_=bat
        elif [[ $option_ == -l ]]; then command_="ls -l"
        elif [[ $option_ == -s ]]; then command_=whyp_source
        elif [[ $option_ == -v ]]; then command_="$vim_command_"
        fi
        shift
    fi
    [[ "$command_" ]] || return 2
    $command_ $path_
    [[ $command_ == "$vim_command_" ]] && whyp_source $path_
}
