#! /bin/cat

# . ~/jab/src/bash/f.sh


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

bash_null () {
    echo ~/bash/null 
}

fynd () {
    sudo find "$@"
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
