#! /bin/bash

JAB=~/.jab

link_to_home ()
{

	local from=$JAB/$1
	if [ -e $from ]
	then ln -s $from $HOME/.$(basename $1)
	else echo $from does not exist >&2
	fi
}

link_to_ipython ()
{
	local parent=$HOME/.ipython
	[ -d $parent ] || mkdir -p $parent 
	ln -s $JAB/ipython/$1 $parent 
}

link_subversion_config ()
{
	local sub_sversion=$(svn --version | head -n 1 | cut -d\   -f3 | cut -d. -f2)
	if [ $sub_version > 6 ]
	then echo svn version is too high >&2
	else
		local subversion=$HOME/.subversion
		[ -f $subversion/config ] && rm -f $subversion/config
		[ -d $subversion ] || mkdir -p $subversion
		ln -s $JAB/etc/subversion/config $subversion/config
	fi
}

main ()
{
	[ -d $JAB ] || svn co -q --username abrogan https://repository.altobridge.com/jab $JAB
	link_to_home vim
	link_to_home vim/vimrc
	link_to_home python/pythonrc.py
	link_to_home etc/dir_colors
	link_to_home editrc
	link_to_home inputrc
	link_to_ipython config_helper_functions.py
	link_to_ipython ipy_user_conf.py
	link_to_ipython ipythonrc
	link_to_ipython options.conf
	link_subversion_config
}

cd 
main
