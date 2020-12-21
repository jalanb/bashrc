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

gsj () {
    git -C ~/hub/jab status
}

gt () {
    git "$@"
}

gv () {
    g -v "$@"
}

glll () {
    gl_ 16 "$@"
}

gllll () {
    gl_ 32 "$@"
}

glllll () {
    gl_ 64 "$@"
}

gllllll () {
    gl_ 128 "$@"
}

glllllll () {
    gl_ 256 "$@"
}

gllllllll () {
    gl_ 512 "$@"
}

gllllllll () {
    gl_ 1024 "$@"
}

