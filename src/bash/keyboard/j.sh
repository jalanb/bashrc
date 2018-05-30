#! /bin/cat

. ~/bash/jabnet.sh
. ~/keys/k.sh

# x

j () {
    k ~/jab "$@"
}


# xx
jb () {
    ssb "$@"
}

ji () {
    ssi "$@"
}

jm () {
    ssm "$@"
}

jj () {
    if [[ -z "$*" ]]; then
        cde ~/jab
    else
        XKCD=cde k ~/jab "$@"
    fi
}

jv () {
    kv ~/jab
}

# xxx

jjj () {
    XKCD=cde kk ~/jab "$@"
}

jvb () {
    kv ~/jab/src/bash
}

jvy () {
    kv ~/jab/src/python
}

