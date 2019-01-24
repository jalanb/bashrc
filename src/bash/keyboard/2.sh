#! /bin/cat

Welcome_to $BASH_SOURCE

at_home () {
    local _doc="""Try $1 as a directory in, or under, $HOME"""
    if [[ -z "$@" ]]; then
        c ~
        return 0
    fi
    # set -x
    local _name=$1; shift
    local _homed=~/$_name
    [[ -d $_homed ]] || return 1
    local _undername=$1; shift
    [[ $_undername ]] || _undername=$_name
    # Args should overwrite defaults
    local _match_dir=$( (
        cd $_homed
        for _arg_path in $_undername "$@"; do
            if [[ -d $_arg_path ]]; then
                readlink -f $_arg_path
                break
            fi
        done
    ) )
    local _dir=$_homed
    [[ -d "$_match_dir" ]] && _dir="$_match_dir"
    [[ -d "$_dir" ]] || return 1
    CDE_header=$( (cd $_dir; l -d ${_name}* 2>/dev/null ) ) cde $_dir
    # set +x
}

_2 () {
    at_home bash
}

_21 () {
    at_home tools "$@"
}

_22 () {
    at_home jab "$@"
}

_23 () {
    at_home waas "$@"
}

_24 () {
    at_home saas "$@"
}

_25 () {
    at_home bash "$@"
}

_26 () {
    at_home /tmp
}

_27 () {
    at_home /tmp
}

Bye_from $BASH_SOURCE
