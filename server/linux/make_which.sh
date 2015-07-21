#! /bin/bash

set -e

test -d /tmp/Downloads && rm -rf /tmp/Downloads
mkdir /tmp/Downloads
cd /tmp/Downloads

wget http://ftp.gnu.org/gnu/which/which-2.21.tar.gz
tar zxf which-2.21.tar.gz
cd which-2.21/
./configure --prefix=/usr
make
sudo make install
if [[ -f /usr/bin/which ]]; then
    test -f /bin/which && sudo rm -f /bin/which
    sudo ln -s /usr/bin/which /bin/which
fi

rm -rf /tmp/Downloads
