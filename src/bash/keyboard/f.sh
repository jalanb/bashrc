#! /bin/cat

# . ~/jab/src/bash/f.sh

# ffff may be defined in f.sh

# x

alias f=fynd
# _
# xx

alias ff=ffind

fl () {
    freds | tr ' ' '\n'
}

# _x
# xxx

fdd () {
    $(freds -d "$@")
}

fee () {
    $(freds -e "$@")
}

fff () {
    freds | tr ' ' '\n'
}

fll () {
    $(freds -l)
}

frr () {
    $(freds -r "$@")
}

fpp () {
    $(freds -p "$@")
}

fss () {
    $(freds -s "$@")
}

fuu () {
    $(freds -U "$@")
}

vff () {
    $(freds -e "$@")
}

# _xx
# xxxx

fynd () {
    local _arg_1=$1
    if [[ $_arg_1 == "-name" ]]; then
        echo "Do not use '-name'" >&2
        shift
    fi
    local _argc=${#*}
    dir=
    if [[ $_argc > 1 ]]; then
        shift_dir "$@" && shift
    elif [[ -z $dir ]]; then
        dir=$(pwd)
    fi
    local name=$1
    shift
    local old_ifs=$IFS
    IFS=";"
    for FOUND in $(find "$dir" -name "$name" -print "$@" | tr '\n' ';')
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
