#! /bin/bash

install_software () 
{
	sudo apt-get update
	sudo apt-get upgrade
	if [[ -d /media/VBOXADDITIONS_4.2.6_82870/ ]]
	then
		sudo apt-get -y -qq install dkms
		cd /media/VBOXADDITIONS_4.2.6_82870/
		sudo ./VBoxLinuxAdditions.run 
	fi
	sudo apt-get -y -q remove ack
	sudo apt-get -y -qq install apt-file ipython subversion ctags tree gcc libc-dev rlwrap ack-grep tofrodos sshfs guake openssh-server
	sudo apt-get -y -q install zlib1g-dev libreadline6-dev libdb4.8-dev libncurses5-dev
	# for python, from http://askubuntu.com/questions/21547/what-are-the-packages-libraries-i-should-install-before-compiling-python-from-so
	sudo apt-get -y -q install build-essential libz-dev libncursesw5-dev libssl-dev libgdbm-dev libsqlite3-dev libbz2-dev

	cd /usr/bin
	sudo ln -s ack-grep ack
	sudo ln -s fromdos dos2unix
	sudo ln -s todos unix2dos
}

make_software ()
{
	mkdir /tmp/Downloads
	cd /tmp/Downloads
	tar zxf which-2.20.tar.gz
	cd which-2.20/
	./configure
	make
	sudo rm -f /usr/bin/which
	sudo make install

	cd /tmp/Downloads
	wget http://mama.indstate.edu/users/ice/tree/src/tree-1.6.0.tgz
	tar zxf tree-1.6.0.tgz 
	cd tree-1.6.0/
	./configure
	make
	sudo make install
	if python -c "import sys; sys.exit(int(sys.version.split()[0] >= '2.7.4'))"

	cd /tmp/Downloads
	then
		wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
		tar zxf Python-2.7.3.tgz 
		cd Python-2.7.3
		./configure --prefix=$HOME
		make
		sudo make install
		cd ..
		wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
		sh setuptools-0.6c11-py2.7.egg --prefix=$HOME
		easy_install-2.7 pudb
	fi
	sudo rm -rf /tmp/Downloads
}

write_system_startups ()
{
	sudo echo "# ~/.bash_logout: executed by bash(1) when login shell exits" > /root/.bash_logout

	sudo cat > /etc/bash.bashrc << EOB
# System-wide .bashrc file for interactive bash(1) shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

echo Welcome to /etc/bash.bashrc

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- $1
                   return $?
                elif [ -x /usr/share/command-not-found ]; then
		   /usr/bin/python /usr/share/command-not-found -- $1
                   return $?
		else
		   return 127
		fi
	}
fi
echo "Bye from /etc/bash.bashrc"
EOB

	sudo cat > /etc/profile << EOB
# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).
echo Welcome to /etc/profile

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    PS1='\u@\h:\w\$ '
    if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

umask 022
test -d ~/bin && export PATH="~/bin:$PATH"
echo Bye from /etc/profile
EOB

	sudo cat > /etc/profile.d/jab.sh << EOB
# /etc/profile.d/jab.sh
#
# System-wide customizations for all logins

echo Welcome to /etc/profile.d/jab.sh

export EDITOR=/usr/bin/vim
EOB
}

write_root_startups ()
{
	sudo cat > /root/.bashrc << EOB
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

echo Welcome to ~/.bashrc

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

source /home/jab/.jab/colour-environ
source /home/jab/.jab/prompt red

# enable color support of ls
[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

# Alias definitions.
[ -f /root/.bash_aliases ] && source  /root/.bash_aliases

echo Bye from  ~/.bashrc
EOB

	sudo cat > /root/.bash_aliases << EOB
alias grep='grep --color=auto'

alias ls='ls --color=auto'
alias ll='ls -lF'
alias la='ls -a'
alias lr='ls -lhtr'
alias l='ls -CF'

alias inst="/usr/bin/aptitude -y -q install"
alias reinst="/usr/bin/aptitude -y -q reinstall"
EOB

	sudo echo "# ~/.bash_logout: executed by bash(1) when login shell exits" > /root/.bash_logout
}

clean_directories ()
{
	rm -rf Documents/ Music/ Pictures/ Public/ Templates/ Videos/ examples.desktop
	mkdir bin src tmp lib log mnt
}

checkout_jab ()
{
	svn --username  abrogan --password AlrB3@13 cat https://repository.altobridge.com/svn/amg/trunk/trackers/ie-track-1/bin/add_to_a_path.sh > bin/add_to_a_path.sh
	svn co -q --username abrogan https://repository.altobridge.com/jab .jab
	ln -s ~/.jab/vim ~/.vim
	ln -s ~/.jab/vim/vimrc ~/.vimrc
	ln -s ~/.jab/python/pythonrc.py ~/.pythonrc.py
	ln -s ~/.jab/etc/subversion/config ~/.subversion/config
	ln -s ~/.jab/etc/dir_colors ~/.dir_colors
	ln -s ~/.jab/editrc ~/.editrc
	ln -s ~/.jab/inputrc ~/.inputrc
	mkdir -p ~/.ipython
	ln -s ~/.jab/ipython/config_helper_functions.py ~/.ipython
	ln -s ~/.jab/ipython/ipy_user_conf.py ~/.ipython
	ln -s ~/.jab/ipython/ipythonrc ~/.ipython
	ln -s ~/.jab/ipython/options.conf ~/.ipython
	vim -d ~/.jab/etc/subversion/config ~/.subversion/config
}

set_ssh ()
{
	ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa
	if [[ -f ~/.ssh/authorized_keys ]]
	then
		cat ~/.jab/ssh/id_jab.pub >> ~/.ssh/authorized_keys
	else
		cp ~/.jab/ssh/id_jab.pub ~/.ssh/authorized_keys
	fi
	chmod 400 ~/.jab/ssh/id_jab*
	chmod 400 ~/.ssh/authorized_keys
}

mount_disks ()
{
	ln -s /media/sf_C_DRIVE mnt/c
	ln -s /media/sf_M_DRIVE mnt/m
}

write_jab_startup ()
{
	echo "# ~/.bash_logout: executed by bash(1) when login shell exits" > ~/.bash_logout

	cat > ~/.bashrc << EOB
# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

echo Welcome to /home/jab/.bashrc
if [[ $- == *i* ]]
then
		source /home/jab/bin/add_to_a_path.sh
		test -f ~/.jab/bashrc && cd ~/.jab && . bashrc && cd >/dev/null 2>&1
fi
echo Bye from /home/jab/.bashrc
EOB

	cat > ~/.profile << EOB
# ~/.profile: executed by the command interpreter for login shells.

[ -z "$PS1" ] && return
echo Welcome to /home/jab/.profile
[[ -n "$BASH_VERSION" ] && source ~/.bashrc
echo Bye from /home/jab/.profile
EOB

}

as_root ()
{
	install_software
	make_software
	write_system_startups
	write_root_startups
}

as_jab ()
{
	cd
	clean_directories
	checkout_jab
	set_ssh
	write_jab_startup
	mount_disks
	sudo usermod -G vboxsf,adm,dialout,cdrom,plugdev,lpadmin,admin,sambashare jab
}

main ()
{
	as_root
	as_jab
}

main
