#! /bin/cat

# x
# xx

jb () {
    _ssh ja-book.local
}

jn () {
    _ssh jalan-book.local
}

jm () {
    _ssh jalan-mac.local
}

# xxx
# xxxx

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh -q -i ~/.ssh/id_jab $_server
}
