#! /bin/cat

# x

f () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    local _type=f
    [[ $1 =~ ^[dDfF]$ ]] && _type="$1" && shift
    _type="-type $_type"
    local name_='*'
    [[ -n $1 ]] && name_="$1" && shift
    name_="-name $name_"
    find $_dir $_type $name_ "$@"
}

# _
# xx

fa () {
    fv "$@"
}

ff () {
    fdf "$@"
}

fl () {
    freds | tr ' ' '\n'
}

fd_option () {
    local arg_=$1; shift
    local option_="--$1"; shift
    [[ $arg_ == "${option_:1:2}" ]] && arg_=$option_
    [[ $arg_ == "${option_}" ]] && arg_=$option_
    [[ ${arg_:0:5}_ == "--no-" ]] && arg_=$option_
    [[ $arg_ == "$option_" ]] || return 1
    echo "$option_"
}

# xxx

#
fd_ () {
    local __doc__="""fd_ (""$@"")"""
    local dir_=. glob_=. options_==--follow
    for arg_ in "$@"; do
        [[ -f "$arg_" ]] && dir_=$(dirname "$arg_")
        [[ -d "$arg_" ]] && dir_="$arg_"
    done
    local option_=
    for arg_ in "$@"; do
        for option_ in expression type follow; do
            options_="$options_ $(fd_option $arg_ $option_)"
        done
    done
    [[ $1 =~ ^[-] ]] && options_="$options_ $1"
    show_command fd $options_ "$glob_" "$dir_"
    fd $options_ "$glob_" "$dir_"
}

fd_ () {
    local dir_= names_= options_= quiet_=
    local follow_=--follow color_=
    while [[ "$@" ]]; do
        if [[ $1 =~ ^-e$ ]]; then
            shift
            options_="$options_ -e $1"
        elif [[ $1 =~ ^[-](f|-no-follow)$ ]]; then follow_=
        elif [[ $1 =~ ^[-](c|-no-color)$ ]]; then color_='--color=never'
        elif [[ $1 =~ ^[-](q|-quiet) ]]; then quiet_=1
        elif [[ $1 =~ ^-td ]]; then options_="$options_ -td"
        elif [[ $1 =~ ^-tf ]]; then options_="$options_ -tf"
        elif [[ $1 =~ ^-(t|-type) ]]; then
            if [[ $2 =~ [fdle] ]]; then
                options_="$options_ $1 $2"
                [[ $2 =~ ^l ]] && follow_=
                shift
            fi
        elif [[ $1 =~ ^[-] ]]; then options_="$options_ $1"
        elif [[ -d "$1" ]]; then dir_="$1"
        elif [[ -f "$1" ]]; then dir_=$(dirname "$1")
        elif [[ $names_ ]]; then names_="${names_}.${1}"
        else names_="$1"
        fi
        shift
    done
    options_="$options_ $follow_ $color_"
    [[ $names_ ]] || names_=.
    [[ $dir_ ]] || dir_=.
    [[ $quiet_ ]] || show_command fd $options_ "$names_" "$dir_"
    fd $options_ "$names_" "$dir_"
}

fdb () {
    bat $(fdf "$@")
}

fdd () {
    local __doc__="""Find directories"""
    fd_ --type d "$@"
}

fdf () {
    local __doc__="""Find files"""
    fd_ --type f "$@"
}

fdg () {
    local name_="$1"; shift
    fd_ "$name_" "$@" | g "$name_"
}

fdl () {
    local __doc__="""Find links"""
    fd_ --type l "$@"
}

fdp () {
    fd -e py "$@"
}

fdv () {
    vim -p $(fd "$@")
}

fdx () {
    local __doc__="""Find executable files"""
    fd_ --type x "$@"
}

fdy () {
    fde py "$@"
}

fdz () {
    local __doc__="""Find empty files"""
    fd_ --type e "$@"
}

fee () {
    $(freds --edit "$@")
}

fff () {
    freds | tr ' ' '\n'
}

fgg () {
    fgv *.py "$@"
}

fgp () {
    fgv *.py "$@"
}

fgt () {
    fgv *.test *.tests "$@"
}

ftt () {
    fgv *.test *.tests "$@"
}

fll () {
    $(freds --list)
}

frr () {
    $(freds --remove "$@")
}

fpp () {
    $(freds --python "$@")
}

fss () {
    $(freds --shell "$@")
}

fvv () {
    $(freds --edit "$@")
}

# xxxx

# xxxxx

fdout () {
    "$@" 1> ~/fd1
}

fderr () {
    "$@" 2> ~/fd2
}

freds () {
    python ~/jab/src/python/freds.py "$@"
}
