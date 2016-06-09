#! /bin/cat

jb () {
    jabook
    _ssh jab.ook
}

jn () {
    _ssh jalanb.ook
}

jm () {
    _ssh jalanbmac.local
}


_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh $_server
}

