#! /bin/cat

# x
# xx

jb () {
    _ssh jab.ook
}

jn () {
    _ssh jalanb.ook
}

jm () {
    _ssh jalanbmac.local
}

# xxx
# xxxx

_ssh () {
    _server=$1
    [[ $(hostname) == $_server ]] || ssh $_server
}

