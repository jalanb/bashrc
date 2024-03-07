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

# echo $HOME minimal
. ~/.minimal
# echo $HOME whyp
. ~/whyp.sh
# echo $HOME jalanb ackvim
. ~/hub/jalanb/ackvim/ackvim.sh
# echo $HOME jalanb pyth
. ~/hub/jalanb/pyth/pyth.sh
# echo $HOME cde
. ~/cde.sh
# echo $HOME jab environ.d
. ~/jab/environ.d/__init__.sh optional
# echo $HOME bash
. ~/jab/src/bash/__init__.sh
# echo $HOME jalanb local
. ~/jalanb/local/__init__.sh optional
# echo $HOME jab work
. ~/jab/work/__init__.sh optional
#
# better to let whyp re-source itself after all that
#
. ~/whyp.sh
export WHYP_EDITOR=vv

# bring in fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[[ $(uname) == Darwin ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

activate_dir="$HOME/jab/.venv"
[[ -d ".venv" ]] && activate_dir=".venv"
cde_activate_venv $activate_dir
ACTIVE_PYTHON=$(which python)
