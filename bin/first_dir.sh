#! /bin/bash

Welcome_to $BASH_SOURCE

reuse_path () {
    [[ -n $path && -d "$path" ]] && return 0
    shift_path "$@"
    return $?
}

shift_path () {
    path=$(pwd)
    [[ -z "$*" ]] && return 0
    for p in "$@"
    do
        if [[ -f "$p" || -d "$p" ]]; then
            path=$(python -c"import os; print os.path.realpath('$p')")
            return 0
        fi
    done
    [[ $path ]]
}

python_realpath () {
    python -c"import os; print(os.path.realpath('""$@""'))"
}

reuse_dir () {
    [[ -n $dir && -d "$dir" ]] && return 0
    first_dir_arg "$@"
    return $?
}

all_dir_args () {
    dir=
    dirr=   # bash is using "dirs" 
    [[ -z "$*" ]] && return 1
    for _arg in "$@"; do
        [[ -d "$_arg" ]] || continue
        _arg_dir=$(python_realpath "$_arg")
        [[ -z "$dir" ]] && dir="$_arg_dir"
        [[ -z "$dirr" ]] && dirr="$_arg_dir" || dirr="$dirr:$_arg_dir"
    done
    [[ -z "$dirr" ]] && return 1
    [[ $dir ]]
}

any_dir_arg () {
    dir=
    [[ -z "$*" ]] && return 1
    for _arg in "$@"; do
        [[ -d "$_arg" ]] || continue
        dir=$(python_realpath "$_arg")
        return 0
    done
    [[ $dir ]]
}

show_arg_dir () {
    [[ "$*" ]] || return 1
    [[ -d "$1" ]] || return 1
    python_realpath "$1"
    [[ $1 ]]
}

first_dir_arg () {
    dir=$(show_arg_dir "$@")
    [[ $dir ]]
}

show_arg_dir_or_here () {
    local _dir=
    if [[ "$@" ]]; then
        _dir=$(show_arg_dir "$@")
    else
        _dir=$(show_arg_dir $(pwd))
    fi
    [[ -d $_dir ]] || return 1
    echo $_dir
    dir="$_dir"
    true
}

first_arg_dir_or_here () {
    dir=$(show_arg_dir_or_here "$@")
    [[ $dir ]]
}

echo_first_arg_dir_or_here () {
    first_arg_dir_or_here "$@" || return 1
    echo $dir
    [[ $dir ]]
}

alias shift_dir=first_arg_dir_or_here

Bye_from $BASH_SOURCE
