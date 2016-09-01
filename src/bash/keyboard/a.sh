#! /bin/cat

# x
# _
# xx
# _x
# xxx
# _xx

# . ~/jab/src/bash/all_abored.sh

# aaa may be defined in all_abored.sh

#! /bin/cat

# x
# _
. ~/hub/ack2vim/ack2vim.sh

# a is defined in ack2vim.sh

# xx
# _x

# aa is defined in ack2vim.sh


_av () {
    (cd $1; vack "$@")
}

# xxx

# aaa is defined in ack2vim.sh

avb () {
    __doc__="vack all args in ~/jab/src/bash";
    _av ~/jab/src/bash "$@"
}

avd () {
    __doc__="vack all args in $DASHBOARD";
    _av $DASHBOARD "$@"
}

avg () {
    __doc__="vack all args in $GIT";
    _av $GIT "$@"
}

avh () {
    __doc__="vack all args in $HUB";
    _av $HUB "$@"
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

