#! /bin/sh


. environ
test -n "$PS1" || return
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
