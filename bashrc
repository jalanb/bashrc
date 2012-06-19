#! /bin/sh

if [[ $- == *i* ]] # http://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html#Is-this-Shell-Interactive_003f
then
	. environ
	. python-environ
	test -f local/environ && . local/environ
	test -f local/python-environ && . local/python-environ
	test -n "$PS1" || return
	. prompt green
	test -f local/prompt && . local/prompt
	. aliases
	test -f local/aliases && . local/aliases
	. functons
	test -f local/functons && . local/functons
	. bin/j.sh
	/bin/rm -rf tmp/*
	if [[ $USER != "builder" ]]
	then
		cd $JAB/python
		if which python2.7 -c"a=0" >/dev/null 2>&1
		then test -f todo.py && python2.7 todo.py
		fi
		echo
		echo Welcome jab, to $HOSTNAME
		echo
		cd
	fi
	test -f ~/.oldpwd && . ~/.oldpwd
fi
