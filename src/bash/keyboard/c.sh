#! /bin/cat

. ~/jab/src/bash/cde.sh

# cccc may be defined in cde.sh

# x

alias c=cde
# _
# xx

alias cc=ccde

cb () { c ~/bash/ }
ch () { c ~/hub/ }
cj () { c ~/jab/ }
cl () { c "$@" && lk }
cv () { kd $1; v $(basename $1) }
cy () { c ~/python/ }
# _x
# xxx
# _xx

can () { cat -n "$@" }

ccc () {
    cccde "$@"
}
cib () { cn ~/.bashrc }
cjy () { kd ~/jab/src/python "$@" }
clf () { cat ~/jab/local/functons.sh }
clo () { c $(locate "$@") }
# xxxx
calf () { cat ~/jab/local/functons.sh }
# _xxx
# xxxxx

clean () { rfq "$@" }
# _xxxx
# xxxxxx
# _xxxxx
