#! /bin/cat

Welcome_to $BASH_SOURCE
# Load employer's environment

export EMPLOYER_DOMAIN=wwts.com
export EMPLOYER_USERNAME=ab13173

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(realdir $BASH_SOURCE) on $(hostname -f)
