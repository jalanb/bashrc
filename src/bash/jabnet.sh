#! /bin/cat

# x
# xx

ji () {
    _ssh jalanmini.local
}

jn () {
    _ssh jalan-book.local
}

jm () {
    _ssh jalan.mac
}

# xxx

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
