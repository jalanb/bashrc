#! /usr/bin/env head -n 3

# This script is intended to be sourced, not run

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

# echo $HOME/jab/whyp
. ~/whyp.sh
export WHYP_EDITOR=vv
# echo $HOME/jab/ackvim
. ~/hub/jalanb/ackvim/ackvim.sh
# echo $HOME/jab/pyth
. ~/hub/jalanb/pyth/pyth.sh
# echo $HOME/jab/cde
. ~/cde.sh
# echo $HOME/jab/environ.d
. ~/jab/environ.d/__init__.sh optional
# echo $HOME/jab/bash
. ~/jab/src/bash/__init__.sh
# echo $HOME/jab/local
. ~/jalanb/local/__init__.sh optional
# echo $HOME/jab/work
. ~/jab/work/__init__.sh optional

# echo $HOME/jab/uname
[[ $(uname) == Darwin ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

activate_dir="$HOME/jab/.venv"
[[ -d ".venv" ]] && activate_dir=".venv"
cde_activate_venv $activate_dir
ACTIVE_PYTHON=$(which python)
