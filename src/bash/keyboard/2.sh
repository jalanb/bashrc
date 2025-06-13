#! /bin/cat


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


home_cd () {
    local cde_=
    local verbose_=0
    local level_=1
    cd
    for arg_ in "$@"; do
        [[ $arg_ =~ ^-v+$ ]] && verbose_=$(( verbose_ + ${#arg_} - 1 )) && continue
        [[ $arg_ == -e ]] && cde_=cde && continue
        [[ -d "$arg_" ]] || continue
        cd "$arg_"
        level_=$(( $level_ + 1 ))
        [[ $verbose_ > $level_ ]] && pwd
    done
    [[ $verbose_ > 0 ]] && pwd
    [[ $cde_ ]] && cde .
}

home_ls () {
    local _doc="""Try $1, and $1/$2 as a directory under $HOME"""
    local $_dir=$(home_cd -v "$@")
    CDE_header=$( ls -1 -d $ $_dir * 2>/dev/null )
    # set +x
}

home_cde () {
    home_cd -e "$@"
}

home_range () {
    home_cd "$@"
    ranger
}

home_vim () {
    home_cd "$1"
    shift
    vim -p $(fd --follow "$@")    
}

