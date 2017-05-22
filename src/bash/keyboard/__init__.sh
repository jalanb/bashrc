#! /bin/cat

Welcome_to $BASH_SOURCE

_KEYBOARD_DIR=~/jab/src/bash/keyboard
_NAME=$(basename $BASH_SOURCE)

pushd $_KEYBOARD_DIR >/dev/null 2>&1
for _script in $(ls *.sh); do
    [[ $_NAME == "$_script" ]] && continue
    . $_KEYBOARD_DIR/$_script
done
popd >/dev/null 2>&1

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(realdir $BASH_SOURCE) on $(hostname -f)
