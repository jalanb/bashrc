#! /bin/cat

Welcome_to $BASH_SOURCE

_KEYBOARD_DIR=~/jab/src/bash/keyboard
_NAME=$(basename_ $BASH_SOURCE)

pushd $_KEYBOARD_DIR >/dev/null 2>&1
for _script in $(ls *.sh); do
    [[ $_NAME == "$_script" ]] && continue
    . $_KEYBOARD_DIR/$_script
done
popd >/dev/null 2>&1


Bye_from $BASH_SOURCE
