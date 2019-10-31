#! /bin/cat

Welcome_to $BASH_SOURCE

# x
# xx
# xxx

ssa () {
    ssh ab13173@"$@"
}

ssi () {
    sst mini.local "$@"
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

ssga () {
    ssa $(worker twkgit20)
}

ssgb () {
    ssh builder
}

ssx () {
    local _server=$1; shift
    ssu ${_server} "$@"
}

# xxxx

_ssj () {
    _server=$1
    [[ $(hostname) == $_server ]] || sst jab $_server -q "$@"
}

Bye_from $BASH_SOURCE
