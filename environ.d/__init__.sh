#! /bin/cat

DIR=~/jab/environ.d
[[ -n $WELCOME_BYE ]] && echo Welcome to $DIR

. $DIR/jab.sh
. $DIR/environ.sh
. $DIR/python.sh
. $DIR/company.sh 2>/dev/null
. $DIR/ssh_completion.sh
[[ -n $WELCOME_BYE ]] && echo Bye from $DIR
