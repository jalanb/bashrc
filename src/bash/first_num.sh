#! /bin/cat

Welcome_to $BASH_SOURCE

first_num () {
    num=$(pyth ~/jab/src/python/first_num.py "$@")
    args=$(pyth ~/jab/src/python/first_num.py --Invert "$@")
    [[ -n $num ]]
}

Bye_from $BASH_SOURCE
