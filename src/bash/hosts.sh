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
    vim ~/jab/hss/hosts \
        -p /etc/hosts \
        +/'Host[a-z]*' \

}

Bye_from $BASH_SOURCE
