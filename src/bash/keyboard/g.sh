#! /usr/bin/env bat


g () {
    git "$@"
}

gr () {
    if [[ "$@" ]]; then
        egrep "$@" | cut_err  "Is a directory" | egrep --color=auto "$@"
    else
        show_command git pull --rebase
        git pull --rebase
    fi
}

gv () {
    grep -v "$@"
}

ght () {
    gh "$@" | tel
}

ghv () {
    local __doc__="edit stuff from history"
    history | grep -v "\<\(history\|gh\)\>" | sed -e "s/^ *[0-9]\+ *//" -e "s/\([JFMASOND][a-z][a-z].[0-9][0-9] - [0-9:]\+\)\( \+\)/\1=/" | vim - +/"$@"
}

gre () {
    [[ -z $* ]] && echo "gre what?" >&2 || $(which grep) -h --color=never "$@"
}

gre () {
    if [[ "$@" ]]
    then gr "$@"
    else 
        echo "gre what?" >&2
        return 1
    fi
}

grv () {
    gr -v "$@"
}

gv. () {
    PYTHONPATH=$(realpath .) gv .
}

gvd () {
    EDITOR=gvim vd "$@"
}

# xxxx
#
grbp () {
    local __doc__"""coulded grep"""
}

gree () {
    local options_= arg_= list_=
    local paths_=
    (
        set -x
        for arg_ in "$@"; do
            [[ -e $arg_ ]] && list_=paths_ || list_=options_
            $$list_="$$list_ $arg_"
        done
        gr $options_ $paths_
    )
}

# xxxxx
#
# xxx_xxx
#
cut_err () {
    # See SO for the fancy piping: https://stackoverflow.com/a/2381643/500942
    #   Allows cutting text out of stderr
    local text_="$1"; shift
    (cat "$@" 3>&1 1>&2 2>&3 | sed -e "/${text_}/d") 3>&1 1>&2 2>&3
}
