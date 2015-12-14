#! /bin/cat -n

export REQUIRE_SH=$(readlink -f $BASH_SOURCE)

_require () {
    _source=source
    if ! what -q source_what 2>/dev/null; then
        $_source $HUB/what/what.sh
        _source=source_what
    elif [[ -d $HUB ]]; then
        $_source $HUB/what/what.sh
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
        _src=$JAB/src
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

_require_file () {
    echo "_require_file ($*)"
    (set -x; echo "set -x; $(readlink -f $BASH_SOURCE) +${LINENO} / BASH_LINENO: ${BASH_LINENO[*]} ${FUNCNAME[0]:+${FUNCNAME[0]}(): }"
    _lines;
        cd $1;
        _require $(_ls_dot_sh $2))
}

_lines () {
    echo "echoed from ${BASH_SOURCE[$i+1]} at line number ${BASH_LINENO[*]}"
}

require () {
    echo "require ($*)"
    (set -x; echo "set -x; $(readlink -f $BASH_SOURCE) +${LINENO} / BASH_LINENO: ${BASH_LINENO[*]} ${FUNCNAME[0]:+${FUNCNAME[0]}(): }"
    _lines;
        local _dirname=.
        if [[ -d $1 ]]; then _dirname=$1; shift; fi
        [[ ! -d $1 ]] && _require_file $_dirname $1)
}

requires () {
    echo "requires ($*)"
    local _dirname=.
    if [[ -d $1 ]]; then
        _dirname=$1
        shift
    fi
    (set -x; echo "set -x; $(readlink -f $BASH_SOURCE) +${LINENO} / BASH_LINENO: ${BASH_LINENO[*]} ${FUNCNAME[0]:+${FUNCNAME[0]}(): }"
    _lines;
        echo "require $_dirname, then require $*";
        for arg in $*; do
            require $dirname $arg;
        done;)
}

require_sh () {
    _require $(_ls_dot_sh $1)
}

