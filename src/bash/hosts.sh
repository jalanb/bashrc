#! /bin/cat


# x
# xx
# xxx
# xxxx
# xxxxx

hosts () {
    grep --color -e ^Host -e Host[nN]ame ~/jab/hss/hosts
}

# xxxxxx

vhosts () {
    local servers_=
    [[ -f servers ]] && servers_=servers
    [[ -f inventory ]] && servers_=inventory
    vim -p \
        ~/.ssh/config \
        $servers_ \
        ~/.git-credentials \
        ~/jab/src/bash/jabnet.sh \
        /etc/hosts \
        "$@" \
        +/'Host[a-z]*' \
        ;

    . ~/jab/src/bash/jabnet.sh
}

