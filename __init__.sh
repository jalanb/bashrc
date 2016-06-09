#! /bin/cat

JAB=$(dirname "$(readlink -f $BASH_SOURCE)")
export JAB


. ~/jab/../what/what.sh
. ~/jab/src/bash/hub.sh
. $HUB/ack2vim/ack2vim.sh
. $HUB/ack2vim/grep_vim.sh
. $HUB/kd/kd.sh
. $HUB/what/what.sh

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh

echo Bye from ~/jab on $(hostname -f)
