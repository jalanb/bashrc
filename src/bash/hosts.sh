#! /bin/cat

Welcome_to $BASH_SOURCE

# x
# xx
# xxx
# xxxx
# xxxxx

hosts () {
    g -e ^Host -e Host[nN]ame ~/jab/hss/hosts
}

# xxxxxx

vhosts () {
    vim -p \
        ~/.ssh/config \
        ~/.git-credentials \
        ~/jab/src/bash/jabnet.sh \
        /etc/hosts \
        "$@" \
        +/'Host[a-z]*' \
        ;

    . ~/jab/src/bash/jabnet.sh
}

Bye_from $BASH_SOURCE
