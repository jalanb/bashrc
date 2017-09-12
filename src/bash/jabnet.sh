#! /bin/cat

Welcome_to $BASH_SOURCE

# x
# xx
# xxx

jai () {
    _ssh jalanmini.local
}

jab () {
    _ssh jalan-book.local
}

jam () {
    _ssh jalan.mac
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

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh -q -i ~/.ssh/id_jab $_server
}

Bye_from $BASH_SOURCE
