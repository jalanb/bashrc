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
    local _underhomed=$_homed/$_name
    [[ -d $_homed ]] || [[ -d $_underhomed ]] || return 1
    [[ -d $_homed ]] || _homed=$_underhomed
    # Args should overwrite defaults
    local _match_dir=$( (
        [[ -d $_homed ]] && ( 
            cd $_homed
            for _arg_path in "$@"; do
                if [[ -d $_arg_path ]]; then
                    readlink -f $_arg_path
                fi
            done
        )
    ) )
    [[ -d "$_match_dir" ]] && _homed="$_match_dir"
    [[ -d "$_homed" ]] || return 1
    CDE_header=$( (cd $_homed; l -d ${_name}* 2>/dev/null ) ) cde $_homed
    # set +x
}

_2 () {
    at_home bash
}

_21 () {
    at_home tools.master "$@"
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
