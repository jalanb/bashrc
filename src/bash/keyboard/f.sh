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

# _x
# xxx

fdd () {
    $(freds --debug "$@")
}

fee () {
    $(freds --edit "$@")
}

fff () {
    freds | tr ' ' '\n'
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

vfd () {
    vim -p $(fd "$@")
}

vff () {
    $(freds --edit "$@")
}

# _xx
# xxxx

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

ffind () {
    local __doc__="ff $dir $filename # finds files with that name in that dir"
    shift_dir "$@" && shift
    filename=$1; shift
    find $dir -type f -name $filename "$@"
}
# _xxxx
# xxxxxx
# _xxxxx
