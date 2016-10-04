#! /bin/cat

[[ -n $WELCOME_BYE ]] && echo Welcome to $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)

