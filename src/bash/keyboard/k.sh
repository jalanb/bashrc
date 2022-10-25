#! /bin/cat

# x

k () {
    local dir_="$1"; shift
    [[ "$dir_" ]] || dir_=.
    [[ -d "$dir_" ]] || return 1
    cd $dir_; 
    "$@"
}

# xx

kl () {
    k "$1" l
}

# xxx

kad () {
    head -n1 | grep -q '#!' || return;
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
