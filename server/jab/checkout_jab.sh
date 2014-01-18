#! /bin/bash

JAB=${JAB:-$HOME/.jab}

link_to ()
{
	[ -h $2 ] || ln -s $1 $2
}

link_to_config ()
{
	for source_dir in $(find $JAB/etc/config -type d)
	do
		dest_dir=$(echo $source_dir | sed -e "s:$JAB/etc/config:$HOME/.config:")
		if [[ ! -e $dest_dir ]]
		then mkdir -p $dest_dir
		# else echo "$dest_dir already exists" >&1
		fi
	done
	for source_file in $(find $JAB/etc/config -type f)
	do
		dest_link=$(echo $source_file | sed -e "s:$JAB/etc/config:$HOME/.config:")
		if [[ -L $dest_link ]]
		then
			source_link=$(readlink -f $dest_link)
			if [[ $source_link != $source_file ]]
			then "$dest_link is linked to $source_link (not $source_file)" >&2
			# else echo "$dest_link is already linked to $source_link"
			fi
		elif [[ -e $dest_link ]]
		then echo "$dest_link exists and is not a link" >&2
		else
			dest_dir=$(dirname $dest_link)
			if [[ -d $dest_dir ]]
			then ln -s $source_file $dest_link
			else echo "$dest_dir is not a directory (for $dest_link)" >&2
			fi
		fi
	done
}

link_to_home ()
{

	local from=$JAB/$1
	if [ -e $from ]
	then link_to $from $HOME/.$(basename $1)
	else echo $from does not exist >&2
	fi
}

link_to_ipython ()
{
	local parent=$HOME/.ipython
	[ -d $parent ] || mkdir -p $parent 
	link_to $JAB/ipython/$1 $parent/$1
}

link_subversion_config ()
{
	local sub_version=$(svn --version | head -n 1 | cut -d\   -f3 | cut -d. -f2)
	if [[ $sub_version > 6 ]]
	then echo svn version is too high >&2
	else
		local subversion=$HOME/.subversion
		[ -f $subversion/config ] && rm -f $subversion/config
		[ -d $subversion ] || mkdir -p $subversion
		link_to $JAB/etc/subversion/config $subversion/config
	fi
}

checkout ()
{
	if [ -z $JAB ]
	then
		echo please set \$JAB
		return 1
	fi
	[ -d $JAB ] && return 0
	if [ -z $JABS ]
	then
		echo please set \$JABS
		return 1
	fi
	git clone $JABS $JAB
}

link_dots ()
{
	link_to_home vim
	link_to_home vim/vimrc
	link_to_home vim/gvimrc
	link_to_home editrc
	link_to_home inputrc
	link_to_home python/pythonrc.py
	link_to_home etc/dir_colors
	link_to_home etc/ackrc
	link_to_ipython config_helper_functions.py
	link_to_ipython ipy_user_conf.py
	link_to_ipython ipythonrc
	link_to_ipython options.conf
	link_to_ipython ipy_profile_company.py
	link_to_config
	link_subversion_config
}

checkout_submodules ()
{
	git submodule sync
	chmod +w $JAB/src/github/kd
	touch $JAB/src/github/kd/kd.history
	chmod +w $JAB/src/github/kd/kd.history
	chmod -w $JAB/src/github/kd
	chmod +w $JAB/src/github/viack
}

main ()
{
	if checkout
	then
		checkout_submodules
		link_dots
	fi
}

cd 
main
