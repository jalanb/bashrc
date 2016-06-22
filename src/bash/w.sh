#! /bin/cat

what_w () {
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
    w ${1:0:${#1}-1} && return $PASS
    return $FAIL
}

what_ww () {
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


what_www () {
. ~/hub/what/what.sh
    (DEBUGGING=www
    ww $1;
    w $1;
    if is_existing_function $1; then
        (set -x; "$@")
    elif is_existing_alias $1; then
        (set -x; "$@")
    else
        [[ $* =~ \.py ]] && PYTHON_DEBUGGING=-U
        bash -x "$@"
    fi)
}

# x

w () {
    what_ww "$@"
}

# xx

ws () {
    . "$@"
}

ww () {
    w "$@"
    what_w "$@"
}

# xxx

. ~/hub/what/wat.sh

wwm () {
    :
}

www () {
    ww "$@"
    what_www "$@"
}

