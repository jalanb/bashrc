#! /bin/cat -n

Welcome_to $BASH_SOURCE

export REQUIRE_SH=$(realpath $BASH_SOURCE)

_require () {
    _source=source
    if [[ -z $WHAT_SOURCED ]]; then
        echo source what
        if [[ -d ~/hub ]]; then
            $_source ~/hub/what/what.sh
        else
            echo "~/hub is not a directory" >&2
            return 1
        fi
    fi
    if [[ -n $WHAT_SOURCED ]]; then
        _source=source_what
    fi
    $_source "$@"
}

_find_from () {
    find $1 -name $2
}

_re_find () {
    find $1 -name $2
}

_counter () {
    wc -l | sed -e "s/ *//"
}

_require_from () {
    local _repo=$1
    local _basename=$(basename $2)
    local _count=$(_find_from $_repo $_basename | _counter)
    local _found=
    local _src=_repo
    [[ $_count == 0 ]] && continue
    if [[ $_count != 1 ]]; then
        _src=~/jab/src
        _count=$(_find_from $_src $_basename | _counter)
    fi
    if [[ $_count == 1 ]]; then
        _found=$(_re_find $_src $_basename);
    else
        echo "$_count \"${_basename}\"s required:" >&2
        for _found in $(_find_from $_src $_basename); do
            echo "    $_found"
        done
    fi
    [[ -f $_found ]] && _require $_found
}

_ls_dot_sh () {
    local __doc__=""
    local _name=$1
    if [[ -f $1 ]]; then echo $1; return 0; fi
    local _script=${1}.sh
    if [[ -f $_script ]]; then ls $_script; return 0; fi
    (set -e; ls $_script)
}

_require_file_in () {
    cd $1;
    _require $(_ls_dot_sh $2)
}

require () {
    local _dirname=.
    if [[ -d $1 ]]; then _dirname=$1; shift; fi
    [[ ! -d $1 ]] && _require_file_in $_dirname $1
}

requires () {
    echo "requires ($*)"
    local _dirname=.
    if [[ -d $1 ]]; then
        _dirname=$1
        shift
    fi
    echo "require $_dirname, then require $*";
    for arg in $*; do
        require $dirname $arg;
    done;
}

require_sh () {
    _require $(_ls_dot_sh $1)
}

Bye_from $BASH_SOURCE
