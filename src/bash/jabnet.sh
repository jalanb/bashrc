#! /bin/cat

Welcome_to $BASH_SOURCE

# x
# xx
# xxx

ssa () {
    ssh ab13173@"$@"
}

ssi () {
    sst jab.mini "$@"
}

ssb () {
    sst jab.book "$@"
}

ssm () {
    sst jab.mac "$@"
}

ssu () {
    local _server=$1
    shift
    if [[ -z "$@" ]]; then
        ssh -tq $_server "sudo su -"
    else
        ssh -tq $_server "sudo $@"
    fi
}

ssga () {
    ssa twkgit20.wwts.com
}

ssgb () {
    ssh builder
}

ssw () {
    local _server=$1; shift
    ssu ab13173@${_server}.wwts.com "$@"
}

# xxxx

_ssj () {
    _server=$1
    [[ $(hostname) == $_server ]] || sst jab $_server -q "$@"
}

Bye_from $BASH_SOURCE
