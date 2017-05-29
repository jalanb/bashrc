#! /bin/cat

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

# xxxx

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh -q -i ~/.ssh/id_jab $_server
}
