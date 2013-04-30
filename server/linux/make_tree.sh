#! /bin/bash

mkdir /tmp/Downloads
cd /tmp/Downloads

wget http://mama.indstate.edu/users/ice/tree/src/tree-1.6.0.tgz
tar zxf tree-1.6.0.tgz 
cd tree-1.6.0/
./configure
make
sudo make install

rm -rf /tmp/Downloads
