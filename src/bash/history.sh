#! /bin/bash


tease_history () {
    history | sed -e "s/^ *[0-9]*  //"  | grep -v "\<\(history\|gh\)\>"
}

strip_history () {
    HISTTIMEFORMAT= tease_history "$@"
}


