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
    vim ~/jab/hss/hosts \
        -p /etc/hosts \
        +/'Host[a-z]*' \

}
