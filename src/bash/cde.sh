#! /bin/cat

# . ~/jab/src/bash/cde.sh

# cccc may be defined in cde.sh

# x
# _
# xx
# _x
# xxx

cls () {
    local __doc__="clean, clear, ls"
    clean
    clear
    if [[ -n "$@" ]]; then
        lk "$@"
    else
        ld $(pwd)
        echo
    fi
}

cde () {
    kd "$@" || return 1
    _show_todo_here
    echo
    echo
    echo
    show_git_time . | head -n $LOG_LINES_ON_CD_GIT_DIR
    echo
    git_simple_status $(pwd) || lk
}
# _xx
# xxxx

ccde () {
    local __doc__="There's always gcc, on the off chance it's needed"
    c . "$@"
}
# _xxxx
# xxxxx

cccde () {
    1
    cc
}
# _xxxxx
# xxxxxx

