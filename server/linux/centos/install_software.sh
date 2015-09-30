#! /bin/bash

set -e

SCRATCH=/tmp/Downloads

set_up () {
	trap tear_down EXIT
	if [[ -d ${SCRATCH} ]]; then
		 rm -rf ${SCRATCH}/*
	else
		 mkdir ${SCRATCH}
	fi
	cd ${SCRATCH}
}

tear_down () {
	if [[ -d ${SCRATCH} ]]; then
		sudo rm -rf ${SCRATCH}
	fi
}

install () {
    sudo /usr/bin/yum -y -q install "$@"
}

yummy () {
    sudo yum update
    sudo yum upgrade
    install ctags sshfs openssh-server ansible
    install ntfs ntfsprogs ntp
}

get_autocutsel () {
    wget https://github.com/sigmike/autocutsel/releases/download/0.10.0/autocutsel-0.10.0.tar.gz
    tar zxf autocutsel-0.10.0.tar.gz 
    cd autocutsel-0.10.0
    sudo yum -y -q install glibc-devel glibc-devel.i686 libXtst-devel libXaw-devel
    ./configure
    make
    sudo make install
    cd $SCRATCH
}

get_vagrant () {
    wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.rpm
    sudo rpm -i vagrant_1.7.4_x86_64.rpm
    rm -rf vagrant_1.7.4_x86_64.rpm
}

get_ack () {
    curl http://beyondgrep.com/ack-2.14-single-file > ~/bin/ack && chmod 0755 ~/bin/ack
}

services () {
    sudo systemctl start ntpd
    sudo systemctl enable ntpd
    sudo service vboxdrv setup
}

downloads () {
    get_autocutsel
    get_vagrant
}

main () {
    yummy
    services
    downloads
}

set_up
main
tear_down
