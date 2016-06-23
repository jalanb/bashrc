#! /bin/cat

DIR=~/jab/src/bash/keyboard
[[ -n $WELCOME_BYE ]] && echo Welcome to $DIR

for script in ?.sh; do . $DIR/$SCRIPT; done

[[ -n $WELCOME_BYE ]] && echo Bye from $DIR
