#! /bin/cat

. ~/jab/jab/../what/what.sh
. ~/jab/jab/src/bash/hub.sh
. $HUB/ack2vim/ack2vim.sh
. $HUB/ack2vim/grep_vim.sh
. $HUB/kd/kd.sh
. $HUB/what/what.sh

JAB=$HUB/jab
. $JAB/environ.d/__init__.sh
. $JAB/src/bash/__init__.sh
. $JAB/local/__init__.sh

echo Bye from $JAB on $(hostname -f)
