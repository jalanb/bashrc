#! /bin/cat

Welcome_to $BASH_SOURCE


# x

c () {
    cde "$@"
}

# _
# xx

cb () {
    cde ~/bots/bots/bots
}

if [[ ! $ALIAS_CC ]]; then
    unalias cc 2>/dev/null

cc () {
    c $CDE.sh
}
fi

cg () {
    local _where=.
    [[ "$*" ]] && _where="$@"
    c $(git -C "$_where" rev-parse --show-toplevel)
}

ch () {
    cde ~/hub/
}

cj () {
    cde ~/jab/
}

cl () {
    clear
    l "$@"
}

cr () {
    clear
}

# cp is hashed (/usr/local/gnu/cp)

cw () {
    cde $WHYP.sh
}

cv () {
    cde $1; v $(basename_ $1)
}

cy () {
    cde ~/hub/pysyte
}

# _x
# xxx
# _xx

can () {
    cat -n "$@"
}

ib () { cn ~/.bashrc
}

cjy () {
    cd ~/jab/src/python "$@"
}

clf () {
    cat ~/jab/local/functons.sh
}

cla () {
    clear
    la "$@"
}

clo () {
    clear
    lo "$@"
}

cloa () {
    clear
    loa "$@"
}

cloo () {
    cde $(locate "$@")
}

# xxxx
calf () {
    cat ~/jab/local/functons.sh
}

# _xxx
# xxxxx

clean () {
    rf -q "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

Bye_from $BASH_SOURCE
