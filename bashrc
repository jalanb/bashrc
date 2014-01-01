#! /bin/bash

# echo Welcome to $HOME/.jab/bashrc

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

update_jab ()
{
	local svn_ls="$SVN_CLIENT ls --non-interactive"
	local jab_dirs=$($svn_ls --trust-server-cert $JABS 2>&1)
	if [[ $jab_dirs =~ "invalid option: --trust-server-cert" ]]
	then jab_dirs=$($svn_ls  $JABS)
	fi
	if [[ $jab_dirs =~ bin ]]
	then $SVN_CLIENT up -q $JAB
	else
		echo Cannot contact $JABS
		echo Expected \"...bin...\"
		echo Actual $jab_dirs
	fi
	if [[ -d $JAB/.svn ]]
	then $SVN_CLIENT stat $JAB
	elif [[ -d $JAB/.git ]]
	then git status $JAB
	fi
}

source_jab ()
{
	[[ -f $JAB/jab_environ ]] && source $JAB/jab_environ
	local LOCAL=$JAB/local
	[[ -e /usr/bin/svn ]] && SVN_CLIENT=/usr/bin/svn 
	[[ -e /usr/local/bin/svn ]] && SVN_CLIENT=/usr/local/bin/svn 
	update_jab
	source_file $JAB/bin/add_to_a_path.sh
	source_file environ
	source_file $JAB/python-environ optional
	source_file $LOCAL/environ
	source_file $LOCAL/python-environ
	source_file $JAB/prompt green
	source_file $LOCAL/prompt
	source_file $JAB/python/what/what.sh
	what_source $JAB/aliases
	what_source $LOCAL/aliases
	source_file $JAB/functons
	source_file $LOCAL/functons
	source_file $JAB/python/kd/kd.sh
	source_file $JAB/src/github/viack/viack
}

clean_jab()
{
	/bin/rm -rf $JAB/tmp/*
}

show_todo ()
{
	builtin cd $JAB/python
	if python2.7 -c"a=0" >/dev/null 2>&1
	then test -f todo.py && python2.7 todo.py
	else
		local version=$(python -V 2>&1)
		echo "Python version is old ($version)"
	fi
	builtin cd - >/dev/null 2>&1
}

welcome_home ()
{
	show_todo
	if pgrep -fl vim > /dev/null
	then
		echo
		echo --------------------
		echo vim sessions running
		echo --------------------
		pgrep -fl vim
	fi
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
