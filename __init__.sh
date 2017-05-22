#! /bin/cat

realpath () {
    [[ -f ~/jab/bin/realpath ]] && ~/jab/bin/realpath "$@"
}

realdir () {
    for $f in $(realpath "$@"); do
        dirname "$f"
    done
}

Welcome_to () {
    [[ -z $WELCOME_BYE ]] && return
    echo Welcomexto ~/jab on $(hostname -f)
}

Bye_from () {
    [[ -z $WELCOME_BYE ]] && return
    echo Byexfrom ~/jab on $(hostname -f)
}

Welcome_to $BASH_SOURCE

. ~/hub/what/what.sh
. ~/jab/src/bash/hub.sh
. ~/hub/ack2vim/ack2vim.sh
. ~/hub/kd/kd.sh
. ~/hub/what/what.sh

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh

Bye_from $BASH_SOURCE
