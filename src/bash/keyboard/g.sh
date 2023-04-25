#! /usr/bin/env bat


g () {
    git "$@"
}

gr () {
    if [[ "$@" ]]; then
        stderr_strip "Is a directory" "$@"
    else
        grr
    fi
}

gv () {
    local readme="show grep results as vim commands"
    sought="$1"
    shift
    grep "$sought" "$@" | sed -e "s/^/vim /" -e "s|:.*| +/\"$sought\"|" | uniq
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

gree () {
    local options_= arg_= list_=
    local paths_=
    set -x
    for arg_ in "$@"; do
        [[ -e $arg_ ]] && list_=paths_ || list_=options_
        $$list_="$$list_ $arg_"
    done
    gr $options_ $paths_
    set +x
}

stderr_strip () {
    # See SO for the fancy piping: https://stackoverflow.com/a/2381643/500942
    #   Allows cutting text out of stderr
    local text_="$1"; shift
    local grep_="$(which egrep) --color"
    if [[ "$@" ]]; then
        ($grep_ "$@" 3>&1 1>&2 2>&3 | sed -e "/${text_}/d") 3>&1 1>&2 2>&3
    fi
}
