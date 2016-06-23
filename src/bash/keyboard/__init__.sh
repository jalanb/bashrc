#! /bin/cat

DIR=~/jab/src/bash/keyboard
[[ -n $WELCOME_BYE ]] && echo Welcome to $DIR

. $DIR/j.sh
. $DIR/k.sh
. $DIR/l.sh
. $DIR/r.sh
. $DIR/t.sh
. $DIR/v.sh
. $DIR/w.sh

[[ -n $WELCOME_BYE ]] && echo Bye from $DIR
