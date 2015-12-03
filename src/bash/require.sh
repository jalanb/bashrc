SOURCE_WHAT=source

_require () {
    if ! what -q source_what 2>/dev/null; then
        $SOURCE_WHAT $HUB/what/what.sh
        SOURCE_WHAT=source_what
    fi
    echo "$SOURCE_WHAT" "$@"
    (set +x; $SOURCE_WHAT "$@")
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

_require_file () {
    echo "_require_file ($*)"
    (set -x;
        local _start_dir=$(pwd);
        local _dirname=$1;
        local _required=$2;
        local _filename="$_required".sh;
        echo "filename: $_filename, dirname: $_dirname";
        [[ $_dirname != . ]] && cd $_dirname;
        [[ -f $_required ]] && _filename="$_required";
        [[ -f $_filename ]] && _require "$_filename" || _require_from $_dirname $_filename;
        [[ $_start_dir == $(pwd) ]] || cd $_start_dir || echo "do not cd back";
    )
}

require () {
    echo "require ($*)"
    (set -x;
        local _dirname=.;
        if [[ -d $1 ]]; then _dirname=$1; shift; fi;
        echo _require_file $_dirname $1;
        [[ ! -d $1 ]] && _require_file $_dirname $1;
    )
}

requires () {
    echo "requires ($*)"
    local _dirname=.
    if [[ -d $1 ]]; then
        _dirname=$1
        shift
    fi
    (set -x;
        echo "require $_dirname, then require $*";
        for arg in $*; do;
            require $dirname $arg;
        done;
    )
}

jab_require () {
    requires $JAB "$@"
}

export SOURCE_WHAT
