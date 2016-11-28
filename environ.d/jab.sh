#! /bin/cat

[[ -n $WELCOME_BYE ]] && echo Welcome to $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)

. ~/jab/src/bash/repo.sh

_set_jab () {
    if [[ -z ~/jab ]]; then
        echo ~/jab is not set >&2
        return 1
    fi
}

_set_ssh () {
    local home_id=~/.ssh/id_jab
    [[ -f "$home_id" ]] && export JAB_ID=$home_id
    export JAB_SSH=$(dirname $home_id)
}

_set_ls_options () {
    export LS_PROGRAM=$(readlink -f $(which ls))
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
    if _set_jab; then
        _set_ssh
        _set_ls_options
    fi
}

_main

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)
