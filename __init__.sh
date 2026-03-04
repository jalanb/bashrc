#! /usr/bin/env head -n 3

# This script is intended to be sourced, not run

realdir () {
    local _p=
    for _p in $(realpath "$@"); do
        dirname "$_p"
    done
}

# echo $HOME bash/add_to_a_path.sh
. ~/bash/add_to_a_path.sh
# echo $HOME bash/crayons.sh
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
export WHYP_EDITOR=vv
# echo $HOME jalanb ackvim
. ~/hub/jalanb/avs/__main__/ackvim.sh
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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

[[ $(uname) == Darwin ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

jab_venv="$HOME/jab/.venv"
test -f $jab_venv/bin/activate && source $jab_venv/bin/activate
