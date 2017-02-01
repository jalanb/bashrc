#! /bin/cat

. ~/jab/src/bash/cde.sh

# cccc may be defined in cde.sh

# x

alias c=cde

# _
# xx

alias cc=ccde

cb () {
    cde ~/bash/
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

cv () {
    kd $1; v $(basename $1)
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
