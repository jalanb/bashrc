#! /bin/cat

. ~/hub/what/what.sh

what_w=w
what_ww=ww

w () {
    what_ww "$@"
}

ww () {
    what_w "$@"
}

www () {
    DEBUGGING=1
    ww $1;
    w $1;
    if is_existing_function $1; then
        (set -x; "$@")
    elif is_existing_alias $1; then
        (set -x; "$@")
    else
        bash -x "$@"
    fi
    DEBUGGING=
}


