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

# xxx

fd_ () {
    local dir_=. name_=. follow_=--follow options_=
    while [[ "$@" ]]; do
        if [[ $1 =~ ^[fd]$ ]]; then
            options_="$options_ -t $1"
        elif [[ $1 =~ ^[-]*[e]$ ]]; then
            shift
            options_="$options_ -e $1"
        elif [[ $1 =~ ^[-][f]$ ]]; then
            follow_=
        elif [[ -d "$1" ]]; then
            dir_="$1"
        else
            name_="$1"
        fi
        shift
    done
    options_="$options_ $follow_"
    fd $options_ "$name_" "$dir_"
}

fdd () {
    fd_ d "$@"
}

fde () {
    fd_ e "$@"
}

fdf () {
    fd_ f "$@"
}

fdp () {
    fde py "$@"
}

fee () {
    $(freds --edit "$@")
}

fff () {
    freds | tr ' ' '\n'
}

fdb () {
    bat $(fdf "$@")
}

fdd () {
    fd_type d "$@"
}

fdf () {
    fd_type f "$@"
}

fdg () {
    local name_="$1"; shift
    fd_ "$name_" "$@" | g "$name_"
}

fdy () {
    fdf -e py "$@"
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

vff () {
    $(freds --edit "$@")
}

# xxxx

fd_type () {
    local type_=$1 sought_=. dir_=. hidden_=--hidden
    [[ $type_ ]] && type_="-t $type_"
    [[ $2 ]] && sought_=$2
    [[ $3 ]] && dir_=$3
    [[ $4 =~ [-]H ]] && hidden_=
    [[ -d $sought_ ]] && dir_=$sought_ && sought_=.
    fd_ $type_ $hidden_ $sought_ $dir_
}

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
