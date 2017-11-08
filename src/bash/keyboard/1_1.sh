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

head_4 () {
    local _name="$1"; shift
    local _dir=$(first_dir ~/wwts/$_name)
    CDE_header=$( (cd $_dir; l -d "$@") ) cde $_dir
}

head_43 () {
    head_4 tools ../tools*
}

head_44 () {
    head_4 dashboard ../dash*
}

