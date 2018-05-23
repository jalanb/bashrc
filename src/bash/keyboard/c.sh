#! /bin/cat

Welcome_to $BASH_SOURCE



# x

alias c=cde

# _
# xx


cb () {
    cde ~/bash/
}

cc () {
    # gcc has my back
    local _where=.
    [[ -n "$*" ]] && _where="$@"
    c $(dirname_ $(git rev-parse --show-toplevel $_where ))
}

ch () {
    cde ~/hub/
}

cj () {
    cde ~/jab/
}

cl () {
    cde "$@" && lk
}

cr () {
    cde "$@"
    ranger
}

cv () {
    kd $1; v $(basename_ $1)
}

cy () {
    cde ~/python/
}

# _x
# xxx
# _xx

can () {
    cat -n "$@"
}

ccc () {
    cccde "$@"
}

ib () { cn ~/.bashrc
}

cjy () {
    kd ~/jab/src/python "$@"
}

clf () {
    cat ~/jab/local/functons.sh
}

clo () {
    cde $(locate "$@")
}

# xxxx
calf () {
    cat ~/jab/local/functons.sh
}

# _xxx
# xxxxx

clean () {
    rfq "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

Bye_from $BASH_SOURCE
