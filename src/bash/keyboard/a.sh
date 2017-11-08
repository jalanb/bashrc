#! /bin/cat

# _
# x
# _x
# xx

#! /bin/cat

. ~/hub/ack2vim/ack2vim.sh

# a is defined in ack2vim.sh

# _x
# xx

# aa is in ack2vim.sh

# _xx

_av () {
    (cd $1; vack "$@")
}

# xxx

# aaa also ack2vim.sh

avb () {
    __doc__="vack all args in ~/jab/src/bash";
    _av ~/jab/src/bash "$@"
}

avd () {
    __doc__="vack all args in ~/wwts/dashboard";
    _av ~/wwts/dashboard "$@"
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

