#! /bin/cat

# . ~/jab/src/bash/f.sh


# x

f () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    local _type=f
    [[ $1 =~ ^[dDfF]$ ]] && _type="$1" && shift
    _type="-type $_type"
    local _name='*'
    [[ -n $1 ]] && _name="$1" && shift
    _name="-name $_name"
    find $_dir $_type $_name "$@"
}

# _
# xx

fa () {
    fv "$@"
}

ff () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" && shift
    find $_dir -type f -name "$@"
}

fl () {
    freds | tr ' ' '\n'
}

fn () {
    f -name "$@"
}

fv () {
    shift_dir "$@" && shift
    if [[ -z "$@" ]]; then
        echo Nothing to find
    else
        files=$(find $(realpath $dir) -name "$@")
        if [[ -z $files ]]; then
            echo "$@" not found
        else
            echo $files | lines_to_spaces | sed -e "s:^\./::"
            vim -p $files
        fi
    fi
}

# _x
# xxx

fdd () {
    "$@" 1> ~/fd1  2> ~/fd2
}

fee () {
    $(freds --edit "$@")
}

fff () {
    freds | tr ' ' '\n'
}

fdd () {
    fd_type d "$@"
}

fdf () {
    fd_type f "$@"
}

fdg () {
    local name_="$1"; shift
    fd "$name_" "$@" | g "$name_"
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
    fd -t $type_ $sought_ $dir_
}
    
bash_null () {
    echo ~/bash/null
}

fynd () {
    local _options=
    [[ $# == 1 ]] && _options=". -name"
    sudo find $_options "$@"
}

fynd.old () {
    if [[ "$@" =~ -name ]]; then
        echo "Do not use '-name'" >&2
        return 1
        shift
    fi
    dir=
    local _argc=${#*}
    if [[ $_argc > 1 ]]; then
        shift_dir "$@" && shift
    elif [[ -z $dir ]]; then
        dir=$(realpath $(pwd))
    fi
    local _debug=$dir
    local _arg=$1; shift
    local _type=
    if [[ $_arg == "-type" ]]; then
        local _type_type=$1; shift
        _type="-type $_type_type"
        _arg=$1; shift
    fi
    local old_ifs=$IFS
    IFS=";"
        for FOUND in $(find $(realpath "$dir") -name "$_arg" -print "$@" 2>/dev/null | tr '\n' ';')
    do
        relpath -s $FOUND
    done
    IFS=$old_ifs
}
# _xxx
# xxxxx

fdout () {
    "$@" 1> ~/fd1
}

fderr () {
    "$@" 2> ~/fd2
}

ffind () {
    local __doc__="ff $dir $filename # finds files with that name in that dir"
    shift_dir "$@" && shift
    filename=$1; shift
    find $dir -type f -name $filename "$@"
}

freds () {
    python ~/jab/src/python/freds.py "$@"
}
