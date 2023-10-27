#! /usr/bin/env kat -n
#
3d () {
    3l -d "$@" | grep -v -e __pycache__
}

3l () {
    local options_= shifts_=
    [[ $1 =~ ^[-]d$ ]] && options_="-d" && shift
    [[ $1 =~ ^[0-9]+$ ]] && options_="-L $1" && shifts_=1
    [[ $1 =~ ^[-]L$ ]] && options_="$1 $2" && shifts_=2
    [[ $options_ ]] || options_="-L 3"
    [[ $1 =~ ^[-]P$ ]] && options_="$options_ $1 $2" && shifts_=2
    [[ $shifts_ ]] && shift $shifts_
    Tree $options_ "$@"
}

3y () {
    local dir_=.
    if [[ -e "$1" ]]; then
        [[ -d "$1" ]] && dir_="$1"
        [[ -f "$1" ]] && dir_=$(dirname "$1")
        shift
    fi
    3l -P "*.py" $dir_ "$@"  --prune | sed -e 's/^│/ /' -e 's/\\s/_/g' -e 's/[│├└]/ /g' -e 's:──:/:'
}

