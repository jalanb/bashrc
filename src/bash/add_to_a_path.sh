#! /bin/bash
#
# Based on a file found at https://github.com/jalanb/jab.sh/blob/master/add_to_a_path.sh
# See also ./add_to_path.py and ./add_to_path.test
#

#
# Gonna need python
#
#
# Once sourced there is one major command:
#
add_to_a_path_py () {
    python3 ~/jab/src/python/add_to_a_path.py "$@"
}

add_to_a_path () {
    if [[ -z $2 ]]; then
        echo "Usage: add_to_a_path <SYMBOL> <new_path>"
        echo "  e.g. add_to_a_path PYTHONPATH /path/to/pylibs"
    else
        local new_paths_=$(add_to_a_path_py "$@")
        for word in "$@"; do
            [[ $1 =~ - ]] || break
            local shifts_=
            [[ $1 == '-i' || $1 == '--index' ]] && shifts_=2
            shift $shifts_
        done
        if [[ -n $new_paths_ ]]; then
            eval $new_paths_
            export $1
        else
            echo $?
            echo $new_paths_
        fi
    fi
}

add_to_PATH () {
    add_to_a_path PATH "$@"
}

add_dir_to_a_path () {
    [[ -d "$2" ]] || return 1
    add_to_a_path "$@"
}

add_dir_to_PATH () {
    add_dir_to_a_path PATH "$@"
}

show_value () {
    local name_=${1-SHELL}
    local value=${!name_}
    if [[ -z "$value" ]]; then
        echo \$$name_ is not set
    else
        local where=${2-bash}
        printf "$where has set \$$name_ to\n\t$value\n"
    fi
}

setter_arg () {
    local result_=
    [[ $1 =~ bash ]] && result_=1
    [[ $1 =~ user ]] && result_=2
    [[ $result_ ]] || return 1
    echo $result_
    return 0
}

quiet_opt () {
    local result_=
    [[ $1 =~  -[qQ] ]] && result_=1
    [[ $result_ ]] || return 1
    echo $result_
    return 0
}

show_a_path () {
    [[ $1 ]] || return 1
    local setter_=bash
    local quiet_= arg_= name_=
    for arg_ in "$@"; do
        quiet_=$(quiet_opt $arg_) && continue
        setter=$(setter_arg $arg_) && continue
        name_=$1
    done
    [[ $quiet_ ]] || echo "$setter_ has set \$$name_ to:"
    (
        local paths_=${!name_} path_=
        IFS=":" for path_ in $paths_; do
            echo "  $path_"
        done
    )
}

show_path () {
    show_a_path PATH "$@"
}

path () {
    show_path "$@" -q
}

show_ppath () {
    show_a_path PYTHONPATH "$@"
}
