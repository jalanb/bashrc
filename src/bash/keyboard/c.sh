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
# 
# cd () {
#     command cd "$@" || return 1
#     local cde_=$HOME/cde
#     PYTHONPATH=$cde_ $cde_/.venv/bin/python3 -m cde --QUIETLY --add .
# }

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

cdb () {
    cde ~/jab
}

cdj () {
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

cclot () {
    local lots_=$1
    local arg_=$2
    local i_=$3 name_=$4 arg_=$5
    local i_=$2 name_=$3
    [[ $lot_ =~ (-$i_|--$name_) ]]
    [[ $arg_ ]] && echo "lots=${lots}$arg_"
}

clean_clear_ls () {
    local __doc__="clean, clear, ls"
    local dir_=. lots_=- ls_=ls
    [[ $1 ]] && lot_=$1
    cclot "$lots_" n clean && clean
    cclot "$lots_" r clear && clear
    cclot "$lots_" l ls && ls_=
    cclot "$lots_" a all && lots_="${lots_}a"
    cclot "$lots_" 1 one ]] && lots_="${lots_}1tr"
    cclot "$lots_" o long ]] && lots_="${lots_}lhtr"
    cclot "$lots_" w wide ]] && lots_="${lots_}C"
    [[ $lots_ ]] || lots_="${lots_}C"
    [[ -d "$1" ]] && dir_="$1"
    [[ -d "$dir_" ]] || return 1
    [[ $ls_ ]] || return 0
    [[ $lots_ ]] && lots_=-$lots_
    $ls_ $lots_ "$dir_"
}

