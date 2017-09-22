#! /bin/cat

Welcome_to $BASH_SOURCE

first_num () {
    num=$(mython ~/jab/src/python/first_num.py "$@")
    args=$(mython ~/jab/src/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}

Bye_from $BASH_SOURCE
