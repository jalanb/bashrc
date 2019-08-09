#! /bin/cat

realdir () {
    local _p=
    for _p in $(realpath "$@"); do
        dirname "$_p"
    done
}

. ~/bash/welcome.sh
. ~/bash/add_to_a_path.sh

. ~/bash/coloured.sh
source_pythonpath () {
    . "$1"
    show_pythonpath "$1"
}

show_pythonpath () {
    show_green_line PYTHONPATH==$PYTHONPATH after "$1"
}

Welcome_to $BASH_SOURCE

. ~/hub/whyp/whyp.sh
. ~/jab/src/bash/hub.sh
export VIMACK=~/hub/vimack/vimack
. $VIMACK.sh
export CDE=~/hub/cde/cde
. $CDE.sh
. ~/bash/coloured.sh
export WHYP=~/hub/whyp/whyp
. $WHYP.sh
export PYTH=~/hub/pyth/pyth
. $PYTH.sh

_out_funcs=$(declare -f | grep "^[^ ]* ()" | wc -l)

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh optional

Bye_from $BASH_SOURCE
