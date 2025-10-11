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

. ~/jalanb/avs/__main__/ackvim.sh

# That gives us a, aa, aaa, aaaa.
# And ac, ae, af, ah, ai, al, ap, at, ay, av.
# And more

# x
# xx

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

aajj () {
    aa "$@" ~/jalanb/jab
}

alan () {
    sudo -u alan -i
}
