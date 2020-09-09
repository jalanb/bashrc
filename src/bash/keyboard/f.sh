#! /bin/cat

# x
# xx

fl () {
    freds | tr ' ' '\n'
}

# xxx

fd_ () {
    local __doc__="""Always follow links"""
    fd --follow "$@"
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
    local type_=$1 sought_=. dir_=.
    [[ $2 ]] && sought_=$2
    [[ $3 ]] && dir_=$3
    [[ -d $sought_ ]] && dir_=$sought_ && sought_=.
    fd_ -t $type_ $sought_ $dir_
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
