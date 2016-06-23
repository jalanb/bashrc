#! /bin/cat

_DIR=$(dirname $(readlink -f $BASH_SOURCE))
[[ -n $WELCOME_BYE ]] && echo Welcome to $_DIR

for script in ?.sh; do . $_DIR/$SCRIPT; done

[[ -n $WELCOME_BYE ]] && echo Bye from $_DIR
