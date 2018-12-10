#! /bin/cat

realdir () {
    local _p=
    for _p in $(realpath "$@"); do
        dirname "$_p"
    done
}

. ~/jab/src/bash/welcome.sh

Welcome_to $BASH_SOURCE

. ~/hub/whyp/whyp.sh
. ~/jab/src/bash/hub.sh
. ~/hub/vimack/vimack.sh
. ~/hub/kd/cd.sh
. ~/hub/whyp/whyp.sh

_out_funcs=$(declare -f | grep "^[^ ]* ()" | wc -l)

. ~/jab/src/bash/__init__.sh
. ~/jab/environ.d/__init__.sh
. ~/jab/local/__init__.sh optional

Bye_from $BASH_SOURCE
