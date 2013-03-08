#! /bin/bash

mkdir /tmp/Downloads
cd /tmp/Downloads

wget http://carlo17.home.xs4all.nl/which/which-2.20.tar.gz
tar zxf which-2.20.tar.gz
cd which-2.20/
./configure
make
sudo rm -f /usr/bin/which
sudo make install
test -f /usr/local/bin/which && sudo ln -s /usr/local/bin/which /usr/bin/which

cd /tmp/Downloads
wget http://mama.indstate.edu/users/ice/tree/src/tree-1.6.0.tgz
tar zxf tree-1.6.0.tgz 
cd tree-1.6.0/
./configure
make
sudo make install

cd /tmp/Downloads
if python -c "import sys; sys.exit(int(sys.version.split()[0] >= '2.7.4'))"
then
	wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
	tar zxf Python-2.7.3.tgz 
	cd Python-2.7.3
	./configure --prefix=$HOME
	make
	make install
	cd ..
	wget https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
	sh setuptools-0.6c11-py2.7.egg --prefix=$HOME
fi

rm -rf /tmp/Downloads
