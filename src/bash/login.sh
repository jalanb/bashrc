#! /bin/bash

test -d ~/.local_login.sh && source ~/.local_login.sh

LOCAL=/usr/local
[[ -d $LOCAL/gnu ]] && LOCALS="$LOCAL/gnu:$LOCAL/bin" || LOCALS="$LOCAL/bin"
BINS=/usr/bin:/bin:/usr/sbin:/sbin
HOMES=$HOME/bin:$HOME/.local
export PATH=$LOCALS:$BINS:$HOMES:$LOCAL/go/bin
SRC=~/src
HG=$SRC/hg
GIT=$SRC/git
HUB=$GIT/hub
# echo HUB, from bashrc $HUB
JAB=$HUB/jab
# echo JAB, from bashrc $JAB
# echo HOSTNAME, $(hostname -f)

vbb () {
    vim -p ~/.bashrc ~/bin/jabbash.sh ~/bin/jab.sh +/jabbash
}

export PS1="\$? [\u@\h:\$PWD]\n$ "

# echo PATH is now $PATH
source ~/bin/jabbash.sh
sp green
jj
