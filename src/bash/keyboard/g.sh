#! /usr/bin/env bat


# See SO for the fancy piping: https://stackoverflow.com/a/2381643/500942
#   Allows cutting stuff out of stderr

g () {
    local grep_="$(which egrep) --color"
    ($grep_ "$@" 3>&1 1>&2 2>&3 | sed -e "/Is a directory/d") 3>&1 1>&2 2>&3
}

gg () {
    local readme="show grep results as vim commands"
    sought="$1"
    shift
    grep "$sought" "$@" | sed -e "s/^/vim /" -e "s|:.*| +/\"$sought\"|" | uniq
}

gsj () {
    git -C ~/hub/jab status
}

gv () {
    g -v "$@"
}
