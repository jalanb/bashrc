#! /bin/cat

realdir () {
    local _p=
    for _p in $(realpath "$@"); do
        dirname "$_p"
    done
}

. ~/bash/add_to_a_path.sh
. ~/bash/crayons.sh

source_pythonpath () {
    . "$1"
    show_pythonpath "$1"
}

show_pythonpath () {
    show_green_line PYTHONPATH==$PYTHONPATH after "$1"
}

. ~/whyp.sh
export WHYP_EDITOR=vv
. ~/hub/jalanb/ackvim/ackvim.sh
. ~/hub/jalanb/pyth/pyth.sh

. ~/jab/src/bash/__cd__.sh
. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jalanb/local/__init__.sh optional
. ~/jab/work/__init__.sh optional

[[ $(uname) == Darwin ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

cde_activate_venv ~/jab/.venv
ACTIVE_PYTHON=$(which python)
