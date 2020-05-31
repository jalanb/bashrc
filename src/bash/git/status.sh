#! /usr/bin/env bat

stat_modified () {
    [[ $(status_chars_ $1) == " M" ]]
}

stat_added () {
    [[ $(status_chars_ $1) == " A" ]]
}

stat_untracked () {
    [[ $(status_chars_ $1) == "??" ]]
}


