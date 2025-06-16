#! /bin/cat

wp () {
    which_python "$@"
}

wpp () {
    which_pythons "$@"
}

typed () {
    type "$1" >/dev/null 2>&1
    [[ $2 ]] || return 0
    . "$2"
}

typed red ~/bash/crayons.sh

wp () {
    if [[ $1 =~ -[v] ]]; then
        shift
        which_python_version "$@"
    else
        which_python "$@"
    fi
}

# Show last status

wtb () {
    . ~/bash/__init__.sh
}

wtf () {
    [[ "$@" ]] && "$@"
    status_=$?
    local name_=Fail colour_=red
    [[ $1 ]] && status_=$1 && shift
    [[ $status_ == 0 ]] && name_=Pass
    [[ $name_ == Pass ]] && colour_=green
    message_="$status_ $name_  $(face $status_)"
    [[ $colour_ ]] || return 1
    $colour_ $message_
    return $status_
}

wvb () {
    vim -p ~/bash "$@"
}

wvj () {
    vim -p ~/jab/__init__.sh "$@"
}

wvw () {
    vim -p ~/whyp.sh "$@"
}
