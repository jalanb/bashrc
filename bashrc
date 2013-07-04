#! /bin/bash

echo Welcome to $HOME/.jab/bashrc

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

source_jab ()
{
	local LOCAL=$JAB/local
	[[ -e /usr/bin/svn ]] && SVN=/usr/bin/svn 
	[[ -e /usr/local/bin/svn ]] && SVN=/usr/local/bin/svn 
	$SVN up $JAB
	$SVN stat $JAB
	source_file $JAB/bin/add_to_a_path.sh
	source_file environ
	source_file $JAB/python-environ optional
	source_file $LOCAL/environ
	source_file $LOCAL/python-environ
	source_file $JAB/prompt green
	source_file $LOCAL/prompt
	source_file $JAB/functons
	source_file $LOCAL/functons
	source_file $JAB/python/kd/kd.sh
	source_file $JAB/python/what/what.sh
	what_source $JAB/aliases
	what_source $LOCAL/aliases
}

clean_jab()
{
	/bin/rm -rf $JAB/tmp/*
}

show_todo ()
{
	builtin cd $JAB/python
	if which python2.7 -c"a=0" >/dev/null 2>&1
	then test -f todo.py && python2.7 todo.py
	else
		local version=$(python --version 2>&1)
		echo "Python version is old ($ver)"
	fi
	builtin cd - >/dev/null 2>&1
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
		builtin cd $JAB
		source_jab
		clean_jab
		[[ $USER == "builder" ]] || welcome_home
	fi
	source_file ~/.oldpwd optional
}

[[ $- == *i* ]] && jab_bashrc
builtin cd
