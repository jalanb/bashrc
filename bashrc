#! /bin/sh

test -n "$PS1" || return

. environ
. prompt green
. aliases
. functons
. bin/j.sh
/bin/rm -rf tmp/*
test -f todo.txt && cat todo.txt
test -f ~/.oldpwd && . ~/.oldpwd
echo
echo Welcome jab, to $HOSTNAME
echo
