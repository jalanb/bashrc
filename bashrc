#! /bin/sh

. environ
test -n "$PS1" || return
. prompt green
. aliases
. functons
. bin/j.sh
/bin/rm -rf tmp/*
if [[ $USER != "builder" ]]
then
	test -f todo.txt && cat todo.txt
	echo
	echo Welcome jab, to $HOSTNAME
	echo
fi
test -f ~/.oldpwd && . ~/.oldpwd
