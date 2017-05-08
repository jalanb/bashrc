#! /bin/cat

[[ -n $WELCOME_BYE ]] && echo Welcome to $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)
# Load employer's environment

export EMPLOYER_DOMAIN=wwts.com
export EMPLOYER_USERNAME=ab13173

[[ -n $WELCOME_BYE ]] && echo Bye from $(basename $BASH_SOURCE) in $(dirname $(readlink -f $BASH_SOURCE)) on $(hostname -f)
