#! /bin/cat

# Sourcing ackvim gives us 
#     a, aa, aaa, aaaa.
#     ac, ae, af, ah, ai, al, ap, at, ay, av.
#     more
. ~/jalanb/avs/__main__/ackvim.sh

# _
# x
# xx

ab () {
    ack "$@" ~/bash
}

ag () {
    alias | grep "$@"
}

aj () {
    a "$@" ~/jalanb/
}

ak () {
    ack "$@" ~/keys
}

aq () {
    quietly a "$@"
}

# _xx

_av () {
    (cd $1; vack "$@")
}

# xxx

aab () {
    aash "$@" ~/bash
}

aaj () {
    aa "$@" ~/jalanb/
}

add () {
    echo $(($1 + $2))
}

ajb () {
    a "$@" ~/jab/
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

aajj () {
    aa "$@" ~/jalanb/jab
}

alan () {
    sudo -u alan -i
}

args_array() {
    local args=()
    args=("$@")
    echo -n "args[0]:${args[0]}"
    echo -n "args[@]:${args[@]}"
    unset args[0]
    echo -n "args[0]:${args[0]}"
    echo -n "args[@]:${args[@]}"
}
