#! /bin/cat

Welcome_to $BASH_SOURCE

# x
# xx
# xxx

ssi () {
    _ssj jalanmini.local
}

ssb () {
    _ssj jalan-book.local
}

ssm () {
    _ssj jalan.mac
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

ssw () {
    ssu ab13173@$1.wwts.com
}

# xxxx

_ssj () {
    _server=$1
    [[ $(hostname) == $_server ]] || sst jab $_server -q -i ~/.ssh/id_jab
}

Bye_from $BASH_SOURCE
