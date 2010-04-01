#! /bin/sh

. environ
. python-environ
test -f local/environ && . local/environ
test -n "$PS1" || return
. prompt green
. aliases
test -f local/aliases && . local/aliases
. functons
test -f local/functons && . local/functons
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
