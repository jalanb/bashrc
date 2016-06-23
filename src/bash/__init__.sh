#! /bin/cat


DIR=~/jab/src/bash
[[ -n $WELCOME_BYE ]] && echo Welcome to $DIR

. $DIR/tput.sh
. $DIR/aliases.sh
. $DIR/asserts.sh
. $DIR/first_num.sh
. $DIR/functons.sh
. $DIR/github.sh
. $DIR/hosts.sh
. $DIR/history.sh
. $DIR/jabnet.sh
. $DIR/prompt.sh
. $DIR/pt.sh
. $DIR/pym.sh
. $DIR/repo.sh
. $DIR/require.sh
. $DIR/rf.sh
. $DIR/run_python.sh
. $DIR/virtualenvwrapper.sh
. $DIR/keyboard/__init__.sh
. $DIR/git/__init__.sh

[[ -n $WELCOME_BYE ]] && echo Bye from $DIR
