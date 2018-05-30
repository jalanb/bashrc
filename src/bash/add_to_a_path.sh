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
add_to_a_path () {
    if [[ -z $2 ]]; then
        echo "Usage: add_to_a_path <SYMBOL> <new_path>"
        echo "  e.g. add_to_a_path PYTHONPATH /path/to/pylibs"
    else
        DOT_PY=~/jab/src/python/add_to_a_path.py
        local _new_paths=$(python $DOT_PY "$@")
        for word in "$@"; do
            [[ $1 =~ - ]] || break
            shift
        done
        if [[ -n $_new_paths ]]; then
            eval $_new_paths
            export $1
        else
            echo $?
            echo $_new_paths
        fi
    fi
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
    if [[ $1 == "-q" ]]; then _quiet=1; shift; fi
    local name=$1 && shift
    if [[ $1 == "-q" ]]; then _quiet=1; shift; fi
    local setter=bash
    if [[ -n $1 ]]; then 
        setter=$1
        shift
    fi
    [[ $1 == "-q" ]] && _quiet=1
    [[ -n $_quiet ]] || echo "$setter has set \$$name to:"
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

phow_ppath () {
    show_a_path PYTHONPATH "$@"
}
