#! /bin/cat

realdir () {
    local _p=
    for _p in $(realpath "$@"); do
        dirname "$_p"
    done
}

. ~/bash/welcome.sh
. ~/bash/add_to_a_path.sh
. ~/bash/crayons.sh

source_pythonpath () {
    . "$1"
    show_pythonpath "$1"
}

show_pythonpath () {
    show_green_line PYTHONPATH==$PYTHONPATH after "$1"
}

Welcome_to $BASH_SOURCE

# export ALIAS_CC=1 # for cde and whyp

. ~/hub/whyp/whyp.sh
. ~/jab/src/bash/hub.sh
export ACKVIM=~/hub/ackvim/ackvim
. $ACKVIM.sh
export CDE=~/hub/cde/cde
. $CDE.sh
export WHYP=~/hub/whyp/whyp
. $WHYP.sh
export PYTH=~/hub/pyth/pyth
. $PYTH.sh

_out_funcs=$(declare -f | grep "^[^ ]* ()" | wc -l)

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh optional

cde_activate_venv ~/jab/.venv
ACTIVE_PYTHON=$(which python)

Bye_from $BASH_SOURCE
