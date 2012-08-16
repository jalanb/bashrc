#! /bin/sh

source_jab()
{
	. environ
	. $JAB/python-environ
	local LOCAL=$JAB/local
	test -f $LOCAL/environ && . $LOCAL/environ
	test -f $LOCAL/python-environ && . $LOCAL/python-environ
	. prompt green
	test -f $LOCAL/prompt && . $LOCAL/prompt
	. aliases
	test -f $LOCAL/aliases && . $LOCAL/aliases
	. functons
	test -f $LOCAL/functons && . $LOCAL/functons
	. bin/j.sh
}

clean_jab()
{
	/bin/rm -rf tmp/*
}

show_todo ()
{
	cd $JAB/python
	if which python2.7 -c"a=0" >/dev/null 2>&1
	then test -f todo.py && python2.7 todo.py
	fi
	cd - >/dev/null 2>&1
}

welcome_home ()
{
	show_todo
	echo
	echo Welcome jab, to $HOSTNAME
	echo
}

jab_bashrc()
{
	[[ -z $JAB ]] && JAB=.jab
	if [[ ! -d $JAB ]]
	then
		echo i am lost because $JAB is not a directory >&2
	else
		cd $JAB
		source_jab
		clean_jab
		[[ $USER == "builder" ]] || welcome_home
	fi
	test -f ~/.oldpwd && . ~/.oldpwd
}

[[ $- == *i* ]] && jab_bashrc
cd
