#! /bin/cat

# x

l () {
    $(_ls_command) "$@"
}

# xx

l0 () {
    ll -htrLo "$@"
}

la () {
    l -a "$@"
}

lg () {
    l -g "$@"
}

lh () {
    l -lh  "$@"
}

ll () {
    local _long_option=-l
    local _dir_option=
    if [[ -d "$1" ]]; then
        _dir_option=d
        [[ "$1" =~ /$ ]] && _dir_option=a
        [[ "$1" =~ ^[.]*$ ]] && _dir_option=a
    fi
    l $_long_option $_dir_option "$@"
}

lo () {
    l -C "$@"
}

lr () {
    ll -tr "$@"
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
    lx ${_dir}/*.py
}

# xxx

lao () {
    l -1 -a "$@"
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
    ll -a "$@"
}

llr () {
    show_run_command lr "$@"
}

ltr () {
    lr -t "$@"
}

loa () {
    lo -a
}

# _xxxxxxxxxx

_ls_command () {
    local _options="-h -1"
    if _is_ls_option --color; then
        _options="$_options --color"
    elif _is_ls_option -G; then
        _options="$_options -G"
    fi
    if _is_ls_option --classify; then
        _options="$_options --classify"
    elif _is_ls_option -F; then
        _options="$_options -F"
    fi
    _is_ls_option --group-directories-first && _options="$_options --group-directories-first"
    echo "$(_ls_program) $_options"
}

_ls_program () {
    if [[ -z $LS_PROGRAM ]]; then
        LS_PROGRAM=$(which ls 2>/dev/null)
        local _gls=$(which gls 2>/dev/null)
        [[ -x "$_gls" ]] && LS_PROGRAM="$_gls"
        export LS_PROGRAM
    fi
    echo $LS_PROGRAM
    return 0
}

_is_ls_option () {
    $(_ls_program)  --help 2>/dev/null | grep -q -- $1
}
