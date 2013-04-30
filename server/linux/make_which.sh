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

rm -rf /tmp/Downloads
