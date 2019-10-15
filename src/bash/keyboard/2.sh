#! /bin/cat

Welcome_to $BASH_SOURCE

home_echo () {
    local _named=$1; shift
    local _named_too=$1; shift
    local _match_dir=$( (
        cd $_named
        for _arg_path in $_named_too "$@"; do
            if [[ -d $_arg_path ]]; then
                readlink -f $_arg_path
                break
            fi
        done
    ) )
    local _dir=$_named
    [[ -d "$_match_dir" ]] && _dir="$_match_dir"
    [[ -d "$_dir" ]] || return 1
    echo $_dir
}

count_dirs () {
    local _count=0
    (
        cd
        local _arg=
        for _arg in "$@"; do
            [[ $_arg =~ -[ev] ]] && continue
            [[ -d $_arg ]] || continue
            _count=$(( $_count + 1 ))
            cd "$_arg"
        done
        echo $_count
    )
}

cd_home_dirs () {
    local _count=0
    local _cd=
    local _echo=
    local _arg=
    cd
    while [[ $# > 0 ]]
    do
        _arg="$1"
        [[ "$_arg" ]] || break 
        if [[ "$_arg" =~ -[ve] ]]; then
            _[[ $_arg == -v ]] && echo=1
            _[[ $_arg == -e ]] && _cd=cde
            continue
        fi
        [[ -d "$_arg" ]] || continue
        _count=$(( $_count + 1 ))
        cd ""$_arg""
        pwd
        shift
    done
    [[ $_echo ]] && pwd
    return $_count
}

home_ls () {
    local _doc="""Try $1, and $1/$2 as a directory under $HOME"""
    local $_dir=$(cd_home_dirs "$@" && pwd)
    CDE_header=$( ls -1 -d $ $_dir * 2>/dev/null )
    # set +x
}

home_cd () {
    local _return=$(count_dirs "$@")
    cd_home_dirs "$@"
    return $?
}

home_cde () {
    home_cd -e "$@"
}

home_range () {
    cd_home_dirs "$@"
    ranger
}

home_echo () {
    (
        home_cd -v "$@"
    )
}

in_home () {
    local _shifts=$(count_dirs "$@")
    (
        home_cd "$@"
        shift $?
        "$@"
    )
    return $_shifts
}

home_fd () {
    (
        home_cd "$@"
        shift $?
        fd "$@"
    )
}

home_vim () {
    vim -p $(home_fd "$@")    
}

