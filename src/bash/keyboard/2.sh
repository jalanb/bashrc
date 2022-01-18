#! /bin/cat


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
    local cde_=
    local echo_=
    local arg_=
    cd
    while [[ $# > 0 ]]
    do
        arg_="$1"
        [[ "$arg_" ]] || break 
        if [[ "$arg_" =~ -[ve] ]]; then
            [[ $arg_ == -v ]] && echo_=1
            [[ $arg_ == -e ]] && cde_=cde
            shift
            continue
        fi
        if [[ -d "$arg_" ]]; then
            cd "$arg_"
            [[ $echo_ ]] && pwd
        fi
        shift
    done
    [[ $echo_ ]] && pwd
    [[ $cde_ ]] && cde .
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

home_fd () {
    (
        home_cd "$@"
        shift $?
        fd --follow "$@"
    )
}

home_vim () {
    vim -p $(home_fd "$@")    
}

