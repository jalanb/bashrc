#! /bin/cat

# x

l () {
    $(ls_command) "$@"
}

# xx

l0 () {
    l -l -htrLo "$@"
}

la () {
    l -a "$@"
}

lg () {
    l -g "$@"
}

lf () {
  l fred* 2>&1 | grep -q "No such" && echo "fredless" >&2 
  fdf fred
}

lh () {
    l -lh  "$@"
}

ll () {
    local _long_option=-l
    local _dir_option=
    if [[ -d "$1" ]]; then
        _dir_option=-d
        [[ "$1" =~ /$ ]] && _dir_option=-a
        [[ "$1" =~ ^[.]*$ ]] && _dir_option=-a
    fi
    l $_long_option $_dir_option "$@"
}

lo () {
    l -C "$@"
}

lr () {
    l -tr "$@"
}

lt () {
    l -t "$@"
}

lx () {
    l -xtr "$@"
}

ly () {
    local _dir=.
    [[ -d "$1" ]] && _dir="$1" 
    l ${_dir}/*.py
}

# xxx

lao () {
    la -C "$@"
}

lal () {
    l -a -l "$@"
}

llg () {
    local _grep=$1; shift
    if [[ -n "$@" ]]; then
        if [[ -d "$1" ]]; then
            local _dir="$1"
            shift
            ll "$_dir/" "$@"
        else
            ll "$@" 
        fi
    else
        ll ./
    fi | g $_grep
}

lll () {
    ll -tr "$@"
}

llr () {
    lr -l "$@"
}

ltr () {
    lt -r "$@"
}

loa () {
    lo -a "$@"
}

# xxxx

llll () {
    lll -a "$@"
}

lotr () {
    lo -tr "$@"
}

# _xxxxxxxxx

_ls_option () {
    $(_ls_program)  --help 2>/dev/null | grep -q -- $1
}


has_option () {
    $1 --help 2>/dev/null | grep -q -- $2 && return 0
    return 8
}

which_q () {
    which "$1" 2>/dev/null
}

ls_program () {
    local __doc__="""Use ls by default, or gls if available (e.g. macOS)"""
    local which_ls_=$(which_q ls)
    [[ -f $which_ls_ ]] || which_ls_=$(which_q gls)
    [[ -f $which_ls_ ]] || return 1
    readlink -f $which_ls_
}

ls_has_option () {
    local ls_=$(ls_program) || return 1
    has_option "$ls_" "$1"
}

ls_options () {
    local __doc__="""Use available options"""
    local by_dir_= colour_=-G classify_=-F
    if ls_has_option $colour_; then
        colour_=--color
        by_dir_=--group-directories-first
        classify_=--classify
    fi
    echo "-h -1 $colour_ $by_dir_ $classify_"
}


ls_command () {
    echo "$(ls_program)" "$(ls_options)"
}

# _xxxxxxxxxx



LS_COMMAND=$(ls_command) LS_OPTIONS=$(ls_options) LS_PROGRAM=$(ls_program)
export LS_COMMAND LS_OPTIONS LS_PROGRAM
