#! /bin/bash -x
        
status_all () {
    local d_= dir_=
    [[ -d .git ]] && dir_=.
    [[ -d "$1" ]] && dir_="$1" && shift
    git -C "$dir_" status --short "$@"
}

status_all
