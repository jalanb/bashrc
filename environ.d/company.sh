#! /bin/bash

# Load employer's environment

unset SITE
unset PYTHONPATH

export EMPLOYER_DOMAIN=wwts.com
export EMPLOYER_USERNAME=ab13173

if [[ -d /Users/jab ]]; then  # looks like OS X
    USER=abrogan
    if [[ $1 != "local" ]]; then
        if [[ -z $EMPLOYER_SERVER ]]; then
            echo EMPLOYER_SERVER is undefined >&2
        elif ! ping -c 1 -t 3 $EMPLOYER_SERVER >/dev/null 2>&1 ;then
            echo Cannot contact $EMPLOYER_SERVER >&2
        fi
    fi
fi
