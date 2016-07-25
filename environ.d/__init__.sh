#! /bin/cat

ENVIRON_DIR=~/jab/environ.d
[[ -n $WELCOME_BYE ]] && echo Welcome to $ENVIRON_DIR

. $ENVIRON_DIR/jab.sh
. $ENVIRON_DIR/environ.sh
. $ENVIRON_DIR/python.sh
. $ENVIRON_DIR/company.sh 2>/dev/null
. $ENVIRON_DIR/ssh_completion.sh
[[ -n $WELCOME_BYE ]] && echo Bye from $ENVIRON_DIR
