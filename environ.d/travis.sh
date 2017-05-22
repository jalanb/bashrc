#! /bin/cat

Welcome_to $BASH_SOURCE

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(realdir $BASH_SOURCE) on $(hostname -f)

