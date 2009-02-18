#! /bin/sh

test -n "$PS1" || return

source_my ()
{
	test -f $1 && . $*
}

source_my environ
source_my prompt green
source_my aliases
source_my functons
source_my bin/j.sh
/bin/rm -rf tmp/*
echo
echo Welcome jab, to $HOSTNAME
echo
