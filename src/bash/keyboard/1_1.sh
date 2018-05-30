#! /bin/cat

Welcome_to $BASH_SOURCE

known_subs () {
    local _parent=$(basename $(readlink -f .))
    echo "$_parent bin local development master"
}

first_sub () {
    for dir in $(known_subs "$1"); do
        test -d $dir || continue
        break
    done
    echo "$dir"
}

home_path () {
    readlink -f ~/"$1"
}

. ~/bash/add_to_a_path.sh

home () {
    # set -x
    local _name=$1; shift
    local _parent=~/$_name
    local _dir=~/$_name/$_name
    [[ -d $_dir ]] || _dir=$_parent
    [[ -d $_dir ]] || return 1
    # Args should overwrite defaults
    local _match_dir=$( (
        cd $_parent
        for _arg_path in "$@"; do
            if [[ -d $_arg_path ]]; then
                readlink -f $_arg_path
            fi
        done
    ) )
    [[ -d "$_match_dir" ]] && _dir="$_match_dir"
    [[ -d "$_dir" ]] || return 1
    CDE_header=$( (cd $_dir; l -d ${_name}* 2>/dev/null ) ) cde $_dir
    # set +x
}

Bye_from $BASH_SOURCE
