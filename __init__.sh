#! /bin/cat

realpath () {
    [[ -f ~/jab/bin/realpath ]] && ~/jab/bin/realpath "$@"
}

realdir () {
    local _p=
    for _p in $(realpath "$@"); do
        dirname "$_p"
    done
}

. ~/jab/src/bash/welcome.sh

Welcome_to $BASH_SOURCE

. ~/hub/what/what.sh
. ~/jab/src/bash/hub.sh
. ~/hub/vimack/vimack.sh
. ~/hub/kd/kd.sh
. ~/hub/what/what.sh

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh optional

Bye_from $BASH_SOURCE
