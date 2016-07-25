#! /bin/cat

[[ -n $WELCOME_BYE ]] && echo Welcome to w.sh

# x

w () {
    what_w "$@"
}

# xx

ww () {
    what_ww "$@"
}

# xxx

www () {
    what_www "$@"
}

# xxxx
# xxxxx
# xxxxxx

what_ww () {
. ~/hub/what/what.sh
    local __doc__='what(all arguments (whether they like it or not))'
    PASS=0
    FAIL=1
    [[ -z "$@" ]] && return $FAIL
    [[ $1 == -q ]] && return what "$@"
    if [[ $(type -t $1) == "file" ]]; then
        what_file $1
        return $PASS
    fi
    what -v "$@" && return $PASS
    echo $1 not found
    what_ww ${1:0:${#1}-1} && return $PASS
    return $FAIL
}

# xxxxxxx

what_w () {
. ~/hub/what/what.sh
    local __doc__='Show whether the first argument is a text file, alias or function'
    if is_existing_alias $1; then
        alias $1
    elif is_existing_function $1; then
        _de_declare_function $1
        echo vim $path_to_file +$line_number +/$1
    elif which $1 > /dev/null 2>&1; then
        real_file=$(readlink -f $(which $1))
        if [[ $real_file != $1 ]]; then
            echo "$1 -> $real_file"
        fi
        ls -l $(readlink -f $(which $1))
    else type $1
    fi
}

# xxxxxxxx

what_www () {
. ~/hub/what/what.sh
    (DEBUGGING=www
    ww $1;
    w $1;
    local _type=
    [[ $* =~ \.py ]] && _type=python
    file "$@" | grep -q [pP]ython && _type=python
    [[ $* =~ \.sh ]] && _type=shell
    file "$@" | grep -q [sS]hell && _type=python
    if is_existing_function $1; then
        (set -x; "$@")
    elif is_existing_alias $1; then
        (set -x; "$@")
    elif file $(!!)  | grep -q -e script -e text; then
        what_wwm "$@"
    else
        echo 0
    fi)
}

[[ -n $WELCOME_BYE ]] && echo Bye from w.sh
