#! /bin/cat

Welcome_to $BASH_SOURCE

# x

c () {
    cde "$@"
}

# _
# xx


cb () {
    cde ~/bash/
}

cc () {
    local _where=.
    [[ -n "$*" ]] && _where="$@"
    c $(git -C "$_where" rev-parse --show-toplevel)
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
    clear
}

cv () {
    cde $1; v $(basename_ $1)
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
    cd ~/jab/src/python "$@"
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
