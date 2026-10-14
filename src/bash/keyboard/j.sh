#! /bin/cat

. ~/bash/jabnet.sh
. ~/keys/k.sh

# x

j () {
    jd ~/jab
}

# xx

jab () {
    sudo -u jab -i
}

jdd () {
    kk /opt/clones/github/jalanb "$@"
}

jjb () {
    kk ~/bash "$@"
}

jjj () {
    . ~/jab/__init__.sh
}

jjy () {
    kk ~/jab/src/python "$@"
}

jjjj () {
    cde_activate_venv ~/jab/.venv
}

# xxx

jalanb () {
    sudo -u jalanb -i
}
