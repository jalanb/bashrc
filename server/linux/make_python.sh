#! /bin/bash

mkdir /tmp/Downloads
cd /tmp/Downloads

if python -c "import sys; sys.exit(int(sys.version.split()[0] >= '2.7.4'))"
then
	wget http://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz
	tar zxf Python-2.7.5.tgz 
	cd Python-2.7.5
	./configure --prefix=$HOME
	DISTRO=$(lsb_release -a 2>/dev/null | grep "Distributor ID" | cut -d\: -f 2 | tr -d ' \t')
	if [[ $DISTRO == "Ubuntu" ]]
	then
		sed -i -e "s|#SSL=/usr/local/ssl|SSL=/usr|" -e "s|^#_ssl|_ssl|" -e "/lssl/s/#//" -e "/USE_SSL/s/#//" Modules/Setup
	fi
	make
	make install
	cd ..
	wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
	sh setuptools-0.6c11-py2.7.egg --prefix=$HOME
	easy_install-2.7 pudb
fi

rm -rf /tmp/Downloads
