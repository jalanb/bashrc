#! /bin/bash

set -e

yummy () {
    sudo yum update
    sudo yum upgrade
    # test -f guest_additions.sh && /bin/bash guest_additions.sh
    sudo /usr/bin/yum -y -q install ctags sshfs openssh-server
    curl http://beyondgrep.com/ack-2.14-single-file > ~/bin/ack && chmod 0755 ~/bin/ack
}

get_autocutsel () {
    wget https://github.com/sigmike/autocutsel/releases/download/0.10.0/autocutsel-0.10.0.tar.gz
    tar zxf autocutsel-0.10.0.tar.gz 
    cd autocutsel-0.10.0
    sudo yum -y -q install glibc-devel glibc-devel.i686 libXtst-devel libXaw-devel
    ./configure
    make
    sudo make install
}

downloads () {
    local HERE=$(pwd)
    cd ~/Downloads
    get_autocutsel
    cd $HERE
}

main () {
    yummy
    downloads
}

main
