#! /bin/cat

. ~/src/git/hub/what/what.sh
. ~/src/git/hub/jab/src/bash/hub.sh
. $HUB/ack2vim/ack2vim.sh
. $HUB/ack2vim/grep_vim.sh
. $HUB/kd/kd.sh
. $HUB/what/what.sh

JAB=$HUB/jab
. $JAB/src/bash/__init__.sh
. $JAB/environ.d/__init__.sh
. $JAB/local/__init__.sh

echo Bye from $JAB on $(hostname -f)
