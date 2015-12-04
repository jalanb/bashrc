#! /bin/cat -n

REQUIRE=$BASH_SOURCE

source $HUB/what/what.sh

_find_from () {
    (set -x;
        set -e;
        find $1 -name $2;
    ) 2>/dev/null
}

_re_find () {
    find $1 -name $2
}

_counter () {
    wc -l | sed -e "s/ *//"
}

_require_from () {
    (set -x;
        set -e;
        echo "_require_from ($1, $2)"
        local _repo=$1;
        local _filename=$(_name_dot_sh $2)
        local _basename=$(basename $_filename);
        local _count=$(_find_from $_repo $_basename | _counter);
        local _src=_repo;
        [[ $_count == 0 ]] && return 1;
        if [[ $_count != 1 ]]; then
            _src=$JAB/src;
            _count=$(_find_from $_src $_basename | _counter);
        fi;
        local _filename=;
        if [[ $_count == 1 ]]; then
            _filename=$(_re_find $_src $_basename);
        else
            echo "$_count \"${_basename}\"s required:" >&2;
            local _finds=$(_find_from $_src $_basename)
            echo "_finds: $_finds"
            for _filename in $_finds; do echo "    $_filename"; done;
        fi;
        [[ -f $_filename ]] && _require_file $_src $_filename;
    ) 2>&1
}

_name_dot_sh () {
    (set -x;
        set -e;
        # echo "_name_dot_sh ($1)";
        local _result="$1".sh;
        [[ -f $1 ]] && _result="$1";
        echo $_result
    )
}

_require_file () {
    (set -x;
        set -e;
        echo "_require_file ($1, $2)"
        local _src=$1;
        local _filename=$(_name_dot_sh $2)
        [[ -f $2 ]] && _filename="$2";
        echo "_src: $_src; ls -d $src";
        echo "_filename: $_filename";
        if [[ $_src == . ]]; then
            [[ -f $_filename ]] && _require $_filename;
        else
            [[ -f $_src/$_filename ]] && (
                cd $_src;
                _require "$_filename"
            ) 2>&1
        fi;
    ) 2>&1
}

require () {
    (set -x;
        set -e;
        echo "require ($1, $2)"
        local _src=.;
        if [[ -d $1 ]]; then _src=$1; shift; fi;
        [[ ! -d $1 ]] && _require_from $_src $1;
    ) 2>&1
}

jab_require () {
    (set -x; set -e;
        echo "jab_require()"
        require $JAB "$@"
    )
}

requires () {
    (set -x;
        set -e;
        echo "requires ($1, $2)"
        local _src=.
        if [[ -d $1 ]]; then
            _src=$1
            shift
        fi
    echo "require \$_src  $_src, then $*";
    for arg in $*; do require $_src $arg; done;
    ) 2>&1
}
