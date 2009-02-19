#! /bin/sh

test -n "$PS1" || return

. environ
. prompt green
. functons
. aliases
. bin/j.sh
/bin/rm -rf tmp/*
echo
echo Welcome jab, to $HOSTNAME
echo
