#! /bin/bash

set -e

SCRATCH=/tmp/Downloads

set_up () {
	trap tear_down EXIT
	if [[ -d "${SCRATCH}" ]]; then
		 rm -rf ${SCRATCH}/*
	else
		 mkdir ${SCRATCH}
	fi
	cd ${SCRATCH}
}

tear_down () {
	if [[ -d "${SCRATCH}" ]]; then
		sudo rm -rf ${SCRATCH}
	fi
}

install () {
    sudo /usr/bin/yum -y -q install "$@"
}

get_more_repositories () {
    sudo rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
    sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    sudo rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
    sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
    sudo wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
}

yummy () {
    sudo yum update
    get_more_repositories
    sudo yum update
    sudo yum upgrade
    install ctags sshfs openssh-server ansible
    install ntfs ntfsprogs ntp libpcap-devel
    install binutils qt gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms
    install VirtualBox-5.0
    install fuse xsel
    install readline-devel.x86_64 bzip2-devel.x86_64 sqlite-devel
    modprobe fuse
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

get_nethogs () {
    rpm -ivh  http://cdn.kanachan.me.uk/dl/rpms/nethogs/nethogs-0.8.0-1.el6.x86_64.rpm
}

services () {
    sudo systemctl start ntpd
    sudo systemctl enable ntpd
    sudo service vboxdrv setup
}

downloads () {
    get_autocutsel
    get_vagrant
    get_ack
    get_nethogs
}

main () {
    yummy
    services
    downloads
}

set_up
main
tear_down
