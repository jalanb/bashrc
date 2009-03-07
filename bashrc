#! /bin/sh

test -n "$PS1" || return

. environ
. prompt green
. aliases
. functons
. bin/j.sh
/bin/rm -rf tmp/*
echo
echo Welcome jab, to $HOSTNAME
echo
test -f todo.txt && cat todo.txt
