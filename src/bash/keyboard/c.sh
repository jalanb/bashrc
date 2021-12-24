#! /bin/cat



# x

c () {
    cde "$@"
}

# _
# xx

cb () {
    cde ~/bots/bots/bots
}

cc () {
    cde $CDE.sh
}

cg () {
    local _where=.
    [[ "$*" ]] && _where="$@"
    cde $(git -C "$_where" rev-parse --show-toplevel)
}

ch () {
    cde ~/hub/
}

cj () {
    cde ~/jab/
}

cl () {
    clean_clear_ls "$@"
}

cr () {
    clean_clear_ls --clean "$@"
}

cs () {
    clean_clear_ls --clear "$@"
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

cdj () {
    cde ~/jab
}

cdn () {
    cde ~/jalanb
}

cjy () {
    cd ~/jab/src/python "$@"
}

cla () {
    clean_clear_ls --all "$@"
}

cll () {
    clean_clear_ls --long "$@"
}

clo () {
    cde $(locate "$@")
}

cls () {
    clean_clear_ls --wide "$@"
}

clla () {
    clean_clear_ls --long --all "$@"
}

# xxxx
# _xxx
# xxxxx

clean () {
    rf -q "$@"
}

# _xxxx
# xxxxxx
# _xxxxx

clean_clear_ls () {
    local __doc__="clean, clear, ls"
    local dir_=. clear_=clear clean_= ls_options_=C
    if [[ $1 =~ --clean ]]; then clean_=clean; shift; fi
    if [[ $1 =~ --clear ]]; then clear_=; shift; fi
    if [[ $1 =~ --all ]]; then ls_options_=${ls_options_}a; shift; fi
    if [[ $1 =~ --long ]]; then ls_options_=${ls_options_}lhtr; shift; fi
    if [[ $1 =~ --wide ]]; then ls_options_=${ls_options_}C; shift; fi
    [[ $ls_options_ ]] || ls_options_=C
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1
    $clear_
    $clean_
    echo l -$ls_options_ "$dir_"
}

