#! /bin/cat

# x
# xx

jb () {
    _ssh jabook.local
}

jn () {
    _ssh jalanbook.local
}

jm () {
    _ssh jalanbmac.local
}

# xxx
# xxxx

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh -i ~/.ssh/id_jab $_server
}

