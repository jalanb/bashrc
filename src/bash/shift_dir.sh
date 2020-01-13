#! /bin/bash

Welcome_to $BASH_SOURCE

. ~/bash/arg_dirs.sh

_show_arg_dir_or_here () {
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

shift_dir () {
    dir=$(_show_arg_dir_or_here "$@")
    [[ $dir ]]
}

Bye_from $BASH_SOURCE

