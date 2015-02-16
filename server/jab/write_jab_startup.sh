#! /bin/bash

cat > ~/.profile << EOB
# ~/.profile: executed by the command interpreter for login shells.

[[ \$- != *i* ]] && return
echo Welcome to /home/jab/.profile
[[ -n "\$BASH_VERSION" ] && source ~/.bashrc
echo Bye from /home/jab/.profile
EOB

cat > ~/.bashrc << EOB
# ~/.bashrc: executed by bash(1) for non-login shells.

echo Welcome to /home/jab/.bashrc
if [[ \$- == *i* ]]; then
	JAB=${JAB:-$HOME/.jab}
	test -f $JAB/bashrc && cd $JAB && . bashrc && cd >/dev/null 2>&1
fi
echo Bye from /home/jab/.bashrc
EOB

echo "# ~/.bash_logout: executed by bash(1) when login shell exits" > ~/.bash_logout
