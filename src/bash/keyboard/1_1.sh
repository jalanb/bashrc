#! /bin/cat

known_dirs () {
    local _stem=$1; shift
    echo "$_stem ${_stem}.local ${_stem}.development ${_stem}.master"
}

first_dir () {
    for dir in $(known_dirs "$1"); do
        test -d $dir || continue
        break
    done
    echo "$dir"
}

wwts_path () {
    readlink -f ~/wwts/"$1"
}

head_4 () {
    local _default="$1"; shift
    _name="$1"; shift
    local _dir=$(first_dir $( wwts_path $_default ))
    [[ -d $_dir ]] || _dir=$(first_dir $( wwts_path $_name ))
    # Args should overwrite defaults
    local _wwts_paths=$( (
        cd ~/wwts
        for _arg_path in "$@"; do
            if [[ -d $( wwts_path $_arg_path ) ]]; then
                wwts_path $_arg_path
            fi
        done | sort | uniq | tr '\n' ' '
    ) )
    local _wwts_dir=$(first_dir $_wwts_paths)
    [[ -d "$_wwts_dir" ]] && _dir="$_wwts_dir"
    [[ -d "$_dir" ]] || return 1
    CDE_header=$( (cd $_dir; l -d ${_name}* 2>/dev/null ) ) cde $_dir
}

head_43 () {
    head_4 tools tools.release "$@"
}

head_44 () {
    head_4 dashboard dashboard.2.7 "$@"
}

