#! /bin/bash

VIM_EDITOR="/usr/bin/vim"
source ${BASH_SOURCE/.sh/_functions.sh}

$VIM_EDITOR "argv.py"
post_vimming "argv.py"
