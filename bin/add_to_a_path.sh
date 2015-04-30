#! /bin/bash
#
# Based on a file found at https://github.com/jalanb/jab.sh/blob/master/add_to_a_path.sh
# See also ./add_to_path.py and ./add_to_path.test
#

if [[ $0 == $BASH_SOURCE ]]; then
    echo "This file should be run as"
    echo "  source $0"
    echo "and should not be run as"
    echo "  sh $0"
fi
#
# Gonna need python
#
_find_python () {
    test -n $PYTHON && return 0
    test -f /usr/bin/python && PYTHON=/usr/bin/python
    test -f /usr/local/bin/python && PYTHON=/usr/local/bin/python
    test -f $JAB/bin/python && PYTHON=$JAB/bin/python
    test -f ~/bin/python && PYTHON=~/bin/python
    test -z $PYTHON && PYTHON=$(which python 2>/dev/null)
    export PYTHON
    test -n $PYTHON
}

#
# Once sourced there is one major command:
#
add_to_a_path () {
    _find_python
    if [[ -z $1 ]]; then
        echo "Usage: add_to_a_path <SYMBOL> <new_path>"
        echo "  e.g. add_to_a_path PYTHONPATH /dev/null"
    else
        local new_paths=$(_run_script "$@")
        if [[ -n $new_paths ]]; then
            eval $1=$new_paths
            export $1
        else
            echo $?
            echo $new_paths
        fi
    fi
}

_run_script () {
    # This function can get called before PATHs are set up
    # If they are set up: use them
    # Else: try sensible defaults around knowing that this script exists

    local jab_parent=$(echo $BASH_SOURCE | sed -e "s/jab.*/jab/")
    local jab=${JAB:-$jab_parent}
    local jab_src_python=$jab/src/python
    local jab_python=${JAB_PYTHON:-$jab_src_python}
    local script=$jab_python/add_to_a_path.py
    if [[ -f $script ]]; then
        local mython=~/bin/python
        [[ -x $mython ]] || mython=/usr/local/bin/python
        [[ -x $mython ]] || mython=/usr/bin/python
        local executable=${PYTHON:-$mython}
        local old_pythonpath=$PYTHONPATH
        local old_library_path=$LD_LIBRARY_PATH
        [[ $PYTHONPATH =~ $jab ]] || export PYTHONPATH=$jab_python/site
        [[ $LD_LIBRARY_PATH =~ $HOME/lib ]] || export LD_LIBRARY_PATH=$HOME/lib
        $executable $jab_python/add_to_a_path.py "$@"
        export PYTHONPATH=$old_pythonpath
        export LD_LIBRARY_PATH=$old_library_path
    else
        echo $script is not a file >&2
        [[ ! -d $jab_python ]] && echo $jab_python is not a dir >&2
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
    local setter=${2-bash}
    local name=${1-PATH}
    echo "$setter has set \$$name to:"
    local old_ifs=$IFS
    IFS=":"
    local path=
    local paths=${!name}
    for path in $paths
    do
        echo "  $path"
    done | sort
    IFS=$old_ifs
}

show_path () {
    show_a_path PATH $*
}

show_ppath () {
    show_a_path PYTHONPATH $*
}

debug_show_a_path () {
    if [[ $DEBUG_PATHS == "yes" ]]; then
        show_a_path $*
    fi
}

debug_show_path () {
    debug_show_a_path PATH $*
}

debug_show_ppath () {
    debug_show_a_path PYTHONPATH $*
}
