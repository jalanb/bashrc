#! /bin/sh

source_file ()
{
	local path_to_file=$1
	shift
	local optional=
	[[ $1 == "optional" || $path_to_file =~ /local/ ]] && optional=1
	
	if [[ -z $path_to_file ]]
	then
		echo No file specified
		set -x
	elif [[ -f $path_to_file ]]
	then
		source $path_to_file $*
	elif [[ -z $optional ]]
	then
		echo \"$path_to_file\" is not a file
	fi
}

source_jab()
{
	local LOCAL=$JAB/local
	source_file environ
	source_file $JAB/python-environ optional
	source_file $LOCAL/environ
	source_file $LOCAL/python-environ
	source_file $JAB/prompt green
	source_file $LOCAL/prompt
	source_file $JAB/aliases
	source_file $LOCAL/aliases
	source_file $JAB/functons
	source_file $LOCAL/functons
	source_file $JAB/bin/j.sh
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
	[[ -z $JAB ]] && JAB=~/.jab
	if [[ ! -d $JAB ]]
	then
		echo i am lost because $JAB is not a directory >&2
	else
		cd $JAB
		source_jab
		clean_jab
		[[ $USER == "builder" ]] || welcome_home
	fi
	source_file ~/.oldpwd optional
}

[[ $- == *i* ]] && jab_bashrc
cd
