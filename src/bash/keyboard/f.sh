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
    local dir_= names_= follow_=--follow options_=
    while [[ "$@" ]]; do
        if [[ $1 =~ ^-(e|-expression)$ ]]; then
            shift
            options_="$options_ --expression $1"
        elif [[ $1 =~ ^[-](f|-no-follow)$ ]]; then follow_=
        elif [[ $1 =~ ^-(t|-type) ]]; then 
            options_="$options_ $1 $2"
            shift
        elif [[ $1 =~ ^[-] ]]; then options_="$options_ $1"
        elif [[ -d "$1" ]]; then dir_="$1"
        elif [[ -f "$1" ]]; then dir_=$(dirname "$1")
        elif [[ $names_ ]]; then names_="${names_}.${1}"
        else names_="$1"
        fi
        shift
    done
    options_="$options_ $follow_"
    [[ $names_ ]] || names_=.
    [[ $dir_ ]] || dir_=.
    fd $options_ "$names_" "$dir_"
}

fdb () {
    bat $(fdf "$@")
}

fdd () {
    fdt d "$@"
}

fde () {
    fd_ --expression "$@"
}

fdf () {
    fdt f "$@"
}

fdg () {
    local name_="$1"; shift
    fd_ "$name_" "$@" | g "$name_"
}

fdt () {
    fd_ --type "$@"
}

fdx () {
    fdt x "$@"
}

fdy () {
    fde py "$@"
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
