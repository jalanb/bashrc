#! /bin/cat

# x
# xx
# xxx
# xxxx
# xxxxx

hosts () {
    g -e ^Host -e Host[nN]ame ~/.ssh/config
}

# xxxxxx

vhosts () {
    vim ~/.ssh/config \
        -p /etc/hosts \
        +/Host \

}
