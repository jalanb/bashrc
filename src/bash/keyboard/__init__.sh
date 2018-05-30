#! /bin/cat

Welcome_to $BASH_SOURCE

_KEYBOARD_DIR=~/bash/keyboard

for _script in $(ls $_KEYBOARD_DIR/*.sh); do
    [[ $(readlink -f $BASH_SOURCE) == $(readlink -f $_script) ]] && continue
    . $_script
done

Bye_from $BASH_SOURCE
