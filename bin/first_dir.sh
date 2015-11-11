#! /bin/bash

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
            path=$(mython -c"import os; print os.path.realpath('$p')")
            return 0
        fi
    done
    return 1
}

reuse_dir () {
    [[ -n $dir && -d "$dir" ]] && return 0
    shift_dir "$@"
    return $?
}

shift_dir () {
    dir=$(pwd)
    [[ -z "$*" ]] && return 0
    for d in "$@"
    do
        if [[ -d "$d" ]]; then
            dir=$(mython -c"import os; print os.path.realpath('$d')")
            return 0
        fi
    done
    return 1
}

first_num () {
    num=$(mython $JAB_PYTHON/first_num.py "$@")
    args=$(mython $JAB_PYTHON/first_num.py NOT_FIRST_NUM "$@")
    [[ -n $num ]]
}
