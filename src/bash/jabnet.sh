#! /bin/cat

# x
# xx

jb () {
    _ssh ja-book.local
}

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
# xxxx

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh -q -i ~/.ssh/id_jab $_server
}
