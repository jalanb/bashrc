#! /bin/cat


# x
# xx
# xxx

ssa () {
    ssh ab13173@"$@"
}

ssi () {
    sst mini.local "$@"
}

ssb () {
    sst book.local "$@"
}

ssm () {
    sst mac.local "$@"
}

ssu () {
    local _server=$1
    shift
    local _sudo="sudo $@"
    [[ -z "$@" ]] && _sudo="sudo su -"
    ssh -tq $_server "$_sudo" || ssh -t $_server "$_sudo"
}

