#! /bin/cat

source_what $JAB/src/bash/repo.sh

_set_jab () {
    JAB=$(path_to_this_repo)
    export JAB
    echo JAB, from repo $JAB
}

_set_ssh () {
    local home_id=~/.ssh/id_jab
    [[ -f "$home_id" ]] && export JAB_ID=$home_id
    export JAB_PUB_ID=$JAB_ID.pub
    export JAB_SSH=$(dirname $JAB_PUB_ID)
}

_set_ls_options () {
    export LS_PROGRAM=$(readlink -f $(which ls))
    export DIRCOLORS=$(readlink -f $(which dircolors))
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
    _set_jab
    _set_ssh
    _set_ls_options
}

_main
