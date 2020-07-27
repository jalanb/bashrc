#! /bin/cat


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
    v \
        ~/.ssh/config \
        ~/.git-credentials \
        ~/jab/src/bash/jabnet.sh \
        /etc/hosts \
        "$@" \
        +/'Host[a-z]*' \
        ;

    . ~/jab/src/bash/jabnet.sh
}

