#! /bin/cat

# x

l () {
    show_run_command $(_ls_command) "$@"
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
    ll -tr "$@"
}

llr () {
    lr -l "$@"
}

ltr () {
    lt -r "$@"
}

loa () {
    lo -a
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

# _xxxxxxxxxx

_ls_command () {
    # echo "$(_ls_program)"      "$(_ls_options)"
      echo "  $LS_PROGRAM "      "  $LS_OPTIONS "
    # echo "  $LS_PROGRAM " "$@" "  $LS_OPTIONS "
}

_ls_program () {
    local __doc__="""Use ls by default, or gls if available (e.g. macOS)"""
    if [[ -z $LS_PROGRAM ]]; then
        LS_PROGRAM=$(which ls 2>/dev/null)
        local _gls=$(which gls 2>/dev/null)
        [[ -x "$_gls" ]] && LS_PROGRAM="$_gls"
    fi
    echo $LS_PROGRAM
}

_ls_options () {
    local __doc__="""Use available options"""
    if [[ -z $LS_OPTIONS ]]; then
        LS_OPTIONS="-h -1"
        if _ls_option --color; then
            LS_OPTIONS="$LS_OPTIONS --color"
            _ls_option --group-directories-first && LS_OPTIONS="$LS_OPTIONS --group-directories-first"
            _ls_option --classify && LS_OPTIONS="$LS_OPTIONS --classify"
        else
            # BSD / macOS has older names for --color and --classify
            _ls_option -G && LS_OPTIONS="$LS_OPTIONS -G"
            _ls_option -F && LS_OPTIONS="$LS_OPTIONS -F"
        fi
    fi
    echo $LS_OPTIONS
}

export LS_PROGRAM=$(LS_PROGRAM= _ls_program)
export LS_OPTIONS=$(LS_OPTIONS= _ls_options)
