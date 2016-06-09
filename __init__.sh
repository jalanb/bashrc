#! /bin/cat

JAB=$(dirname "$(readlink -f $BASH_SOURCE)")
export JAB


. ~/hub/what/what.sh
. ~/jab/src/bash/hub.sh
. ~/hub/ack2vim/ack2vim.sh
. ~/hub/ack2vim/grep_vim.sh
. ~/hub/kd/kd.sh
. ~/hub/what/what.sh

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh

echo Bye from ~/jab on $(hostname -f)
