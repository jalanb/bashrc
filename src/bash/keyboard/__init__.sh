#! /bin/cat

_KEYBOARD_DIR=~/jab/src/bash/keyboard
[[ -n $WELCOME_BYE ]] && echo Welcome to $_KEYBOARD_DIR
_NAME=$(basename $BASH_SOURCE)

pushd $_KEYBOARD_DIR >/dev/null 2>&1
for _script in $(ls *.sh); do
    [[ $_NAME == "$_script" ]] && continue
    . $_script
done
popd >/dev/null 2>&1

[[ -n $WELCOME_BYE ]] && echo Bye from $_KEYBOARD_DIR
