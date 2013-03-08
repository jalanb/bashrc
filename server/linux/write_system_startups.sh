#! /bin/bash


cat > /etc/profile << EOB
# /etc/profile: system-wide profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).
echo Welcome to /etc/profile

add_to_path () {
	if ! echo \$PATH | /bin/egrep -q "(^|:)\$1(\$|:)"
	then
		if [[ -z \$PATH ]]
		then PATH=\$1
		elif [[ -n \$1 && -d \$1 ]] 
		then
			if [ "\$2" = "after" ]
			then PATH=\$PATH:\$1
			else PATH=\$1:\$PATH
			fi
		fi
	fi
}


if [ -x /usr/bin/id ]
then
	[[ -z "\$UID" ]]  && UID=\$(/usr/bin/id -ru)
	[[ -z "\$EUID" ]]  && EUID=\$(/usr/bin/id -u)
	[[ -z "\$GID" ]]  && GID=\$(/usr/bin/id -rg)
	[[ -z "\$EGID" ]]  && EGID=\$(/usr/bin/id -g)
fi


if [ -x /usr/bin/id ]; then
        USER="`id -un`"
        LOGNAME=\$USER
        MAIL="/var/spool/mail/\$USER"
fi

HOSTNAME=`/bin/hostname`
#
# handle history
#
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000


if [ -z "\$INPUTRC" -a ! -f "\$HOME/.inputrc" ]; then
    INPUTRC=/etc/inputrc
fi

export EDITOR=/usr/bin/vim
add_to_path \$HOME/bin
add_to_path /usr/local/bin
add_to_path /usr/bin
add_to_path /bin

export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE INPUTRC

if [ -d /etc/profile.d ]
then
	echo Welcome to /etc/profile.d/
	for i in /etc/profile.d/*.sh
	do
		test -f \$i && source \$i
	done
	unset i
	echo Bye from /etc/profile.d/
fi

if [[ \$- == *i* ]]
then
	if [ "\$BASH" ]
	then
		PS1='\u@\h:\w\$ '
		test -f /etc/bashrc && source /etc/bashrc
		test -f /etc/aliases && source /etc/aliases
	else
		[[ "`id -u`" -eq 0 ]] && PS1='# ' || PS1='$ '
	fi
fi

# We want umask to get set, even for non-interactive, non-login shells.
if [ \$UID -gt 99 ] && [ "`id -gn`" = "`id -un`" ]; then
        umask 002
else
        umask 022
fi

echo Bye from /etc/profile
EOB

cat > /etc/bashrc << EOB
# System-wide bashrc file for interactive bash(1) shells.

echo Welcome to /etc/bashrc

# If not running interactively, don't do anything
[[ \$- != *i* ]] || return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

echo "Bye from /etc/bashrc"
EOB

cat > /etc/aliases << EOB

unalias -a
alias grep='grep --color=auto'

alias ls='ls --color=auto'
alias ll='ls -lF'
alias la='ls -a'
alias lr='ls -lhtr'
alias l='ls -CF'

EOB


