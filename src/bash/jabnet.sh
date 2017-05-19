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
    ssh -tq "$@" "sudo su -"
}

# xxxx

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh -q -i ~/.ssh/id_jab $_server
}
