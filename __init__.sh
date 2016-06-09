#! /bin/cat

JAB=$(dirname $BASH_SOURCE)
export JAB


. ~/jab/jab/../what/what.sh
. ~/jab/jab/src/bash/hub.sh
. $HUB/ack2vim/ack2vim.sh
. $HUB/ack2vim/grep_vim.sh
. $HUB/kd/kd.sh
. $HUB/what/what.sh

. ~/jab/jab/environ.d/__init__.sh
. ~/jab/jab/src/bash/__init__.sh
. ~/jab/jab/local/__init__.sh

echo Bye from ~/jab/jab on $(hostname -f)
