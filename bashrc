#! /bin/sh

source_my ()
{
	test -f $1 && . $*
}

if [ -n "$PS1" ]
then
	source_my environ
	source_my prompt green
	source_my aliases
	source_my functons
	source_my bin/j.sh
	/bin/rm -rf tmp/*
	echo
	echo Welcome jab, to $HOSTNAME
	echo
fi
