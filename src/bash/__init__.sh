#! /bin/cat

Welcome_to $BASH_SOURCE

__version__=0.5.1

_BASH_DIR=~/jab/src/bash
. $_BASH_DIR/tput.sh
. $_BASH_DIR/aliases.sh
. $_BASH_DIR/asserts.sh
. $_BASH_DIR/first_num.sh
. $_BASH_DIR/functons.sh
. $_BASH_DIR/github.sh
. $_BASH_DIR/hosts.sh
. $_BASH_DIR/history.sh
. $_BASH_DIR/jabnet.sh
. $_BASH_DIR/prompt.sh
. $_BASH_DIR/pt.sh
. $_BASH_DIR/pym.sh
. $_BASH_DIR/repo.sh
. $_BASH_DIR/require.sh
. $_BASH_DIR/rf.sh
. $_BASH_DIR/run_python.sh
. $_BASH_DIR/virtualenvwrapper.sh
. $_BASH_DIR/wwts.sh
. $_BASH_DIR/keyboard/__init__.sh
. $_BASH_DIR/git/__init__.sh

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(realdir $BASH_SOURCE) on $(hostname -f)
