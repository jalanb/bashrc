#! /bin/cat

[[ -n $WELCOME_BYE ]] && echo Welcome to ~/jab on $(hostname -f)

. ~/hub/what/what.sh
. ~/jab/src/bash/hub.sh
. ~/hub/ack2vim/ack2vim.sh
. ~/hub/kd/kd.sh
. ~/hub/what/what.sh

. ~/jab/environ.d/__init__.sh
. ~/jab/src/bash/__init__.sh
. ~/jab/local/__init__.sh

[[ -n $WELCOME_BYE ]] && echo Bye from ~/jab on $(hostname -f)
