#! /bin/cat

args_array() {
    local args=()
    args=("$@")
    echo -n "${args[0]} ("
    unset args[0]
    echo -n ${args[@]}
    echo ")"
}

# _

. ~/hub/jalanb/ackvim/ackvim.sh

# x

# a was in ackvim.sh

a () {
    ack_find "$@"
}

# xx

# aa is in ackvim.sh

ab () {
    ack "$@" ~/bash
}

ag () {
    alias | grep "$@"
}

aj () {
    a "$@" ~/jab/
}

ak () {
    ack "$@" ~/keys
}

# _xx

_av () {
    (cd $1; vack "$@")
}

# xxx

# aaa is in ackvim.sh

aab () {
    aash "$@" ~/bash
}

aaj () {
    aa "$@" ~/jalanb
}

add () {
    echo $(($1 + $2))
}

ajj () {
    a "$@" ~/jalanb/
}

asb () {
    red ab "$@" ~/bash
}

ask () {
    local _answer=
    read -e -n1 -p "$1 " _answer
    echo $_answer
}

avb () {
    __doc__="vack all args in ~/jab/src/bash";
    _av ~/jab/src/bash "$@"
}

avg () {
    __doc__="vack all args in ~/src/git";
    _av ~/src/git "$@"
}

avh () {
    __doc__="vack all args in ~/hub";
    _av ~/hub "$@"
}

avj () {
    __doc__="vack all args in ~/jab";
    _av ~/jab "$@"
}

avp () {
    __doc__="vack all args in ~/jab/src/python";
    _av ~/jab/src/python "$@"
}

avs () {
    __doc__="vack all args in ~/src";
    _av ~/src "$@"
}

avu () {
    __doc__="vack all args in ~";
    _av ~ "$@"
}

avv () {
    __doc__="vack all args in ~/jab/vim";
    _av ~/jab/vim "$@"
}


# xxxx

# aaaa is in ackvim.sh

aajj () {
    aa "$@" ~/jalanb/jab
}
