#! /bin/cat

typed () {
    type "$1" >/dev/null 2>&1
    [[ $2 ]] || return 0
    . "$2"
}

typed red ~/bash/crayons.sh

# Show last status
wtf () {
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
