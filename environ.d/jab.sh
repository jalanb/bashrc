#! /bin/cat


dirname_ () {
    local _result=1
    for _arg in "$@"; do
        [[ -e "$_arg" ]] || continue
        dirname "$_arg"
        _result=0
    done
    return $_result
}

basename_ () {
    local _result=1
    for _arg in "$@"; do
        [[ -e "$_arg" ]] || continue
        basename "$_arg"
        _result=0
    done
    return $_result
}

_jab_dir () {
    [[ -d ~/jab ]] || echo ~/jab is not a directory >&2
    [[ -d ~/jab ]] 
}

_set_ssh () {
    local home_id=~/.ssh/id_jab
    [[ -f "$home_id" ]] && export JAB_ID=$home_id
    export JAB_SSH=$(dirname_ $home_id)
}

_set_ls_options () {
    export LS_PROGRAM=$(readlink -f $(/usr/bin/which ls))
    if $LS_PROGRAM -@ >/dev/null 2>&1; then
        export LS_COLOUR_OPTION='-@'
    elif $LS_PROGRAM --color=auto >/dev/null 2>&1; then
        export LS_COLOUR_OPTION='--color=auto'
    else
        export LS_COLOUR_OPTION=
    fi
    if $LS_PROGRAM --group-directories-first >/dev/null 2>&1; then
        export LS_DIRS_OPTION='--group-directories-first'
    else
        export LS_DIRS_OPTION=
    fi
}

_main () {
    if _jab_dir; then
        _set_ssh
        _set_ls_options
    fi
}

_main

Bye_from $BASH_SOURCE
