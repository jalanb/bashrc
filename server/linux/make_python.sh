#! /bin/bash

set -e 

SCRATCH=/tmp/Downloads
MINIMUM_VERSION=2.7.10

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
		rm -rf ${SCRATCH}
	fi
}

install_home_python () {
	wget http://www.python.org/ftp/python/${MINIMUM_VERSION}/Python-${MINIMUM_VERSION}.tgz
	tar zxf Python-${MINIMUM_VERSION}.tgz 
	cd Python-${MINIMUM_VERSION}
	sed -i -e "s|#SSL=/usr/local/ssl|SSL=/usr/local/ssl|" -e "s|^#_ssl|_ssl|" -e "/lssl/s/#//" -e "/USE_SSL/s/#//" Modules/Setup.dist
	./configure --enable-shared --prefix=$HOME 2>&1 > configuring.log
	make 2>&1 > making.log || exit
	make install 2>&1 > installing.log || exit
	cd ..
}

install_home_pip () {
	wget https://bootstrap.pypa.io/get-pip.py | $HOME/bin/python
}

pip_install_modules () {
	$HOME/bin/pip install ipython
	$HOME/bin/pip install pudb
	$HOME/bin/pip install virtualenv
	$HOME/bin/pip install virtualenvwrapper
	$HOME/bin/pip install ansible
}

main () {
	if ! python -c "import sys; from distutils.version import LooseVersion as ver; sys.exit(int(ver(sys.version.split()[0]) < ver('"$MINIMUM_VERSION"')))"; then
		install_home_python
		install_home_pip
		pip_install_modules
	fi
}

set_up
main
tear_down
