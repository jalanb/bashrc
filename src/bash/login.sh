#! /bin/bash

test -d ~/.local_login.sh && source ~/.local_login.sh

LOCAL=/usr/local
[[ -d $LOCAL/gnu ]] && LOCALS="$LOCAL/gnu:$LOCAL/bin" || LOCALS="$LOCAL/bin"
BINS=/usr/bin:/bin:/usr/sbin:/sbin
HOMES=$HOME/bin:$HOME/.local
export PATH=$LOCALS:$BINS:$HOMES:$LOCAL/go/bin
SRC=~/src
GIT=$SRC/git
HUB=$GIT/hub
echo HUB, from bashrc $HUB
JAB=$HUB/jab
echo JAB, from bashrc $JAB
echo HOSTNAME, $(hostname -f)

vbb () {
    vim -p ~/bin/jab.sh ~/bin/jabbash.sh ~/.bashrc +/"^require_scripts_under_jab "
}

export PS1="\$? [\u@\h:\$PWD]\n$ "

echo PATH is now $PATH
source ~/bin/jabbash.sh
sp green
