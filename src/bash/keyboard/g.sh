#! /usr/bin/env bat



g () {
    local grep_="$(which egrep) --color"
    # See SO for the fancy piping: https://stackoverflow.com/a/2381643/500942
    #   Allows cutting text out of stderr
    ($grep_ "$@" 3>&1 1>&2 2>&3 | sed -e "/Is a directory/d") 3>&1 1>&2 2>&3
}

gg () {
    local readme="show grep results as vim commands"
    sought="$1"
    shift
    grep "$sought" "$@" | sed -e "s/^/vim /" -e "s|:.*| +/\"$sought\"|" | uniq
}

rt () {
    git "$@"
}

gv () {
    g -v "$@"
}

}
