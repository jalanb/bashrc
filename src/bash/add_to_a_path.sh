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
            local _shifts=
            [[ $1 == '-i' || $1 == '--index' ]] && _shifts=2
            shift $_shifts
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
    local name=${1-SHELL}
    local value=${!name}
    if [[ -z "$value" ]]; then
        echo \$$name is not set
    else
        local where=${2-bash}
        printf "$where has set \$$name to\n\t$value\n"
    fi
}

show_a_path () {
    local _quiet=
    [[ -z $1 ]] && return 1
    [[ $1 == "-q" ]] && _quiet=1 && shift
    local name=$1 && shift
    [[ $1 == "-q" ]] && _quiet=1 && shift
    local setter=bash
    if [[ -n $1 ]]; then
        setter=$1
        shift
    fi
    [[ $1 == "-q" ]] && _quiet=1 && shift
    [[ $_quiet ]] || echo "$setter has set \$$name to:"
    local old_ifs=$IFS
    IFS=":"
    local path=
    local paths=${!name}
    for path in $paths
    do
        echo "  $path"
    done
    IFS=$old_ifs
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
