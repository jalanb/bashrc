#! /bin/bash

DOWN=/home/alanb/Downloads/Python
test -d $DOWN && rm -rf $DOWN
mkdir -p $DOWN
cd $DOWN

if python -c "import sys; sys.exit(int(sys.version.split()[0] >= '2.7.4'))"; then
    wget http://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
    tar zxf Python-2.7.10.tgz 
    cd Python-2.7.10
    sed -i -e "s|#SSL=/usr/local/ssl|SSL=/usr|" -e "s|^#_ssl|_ssl|" -e "/lssl/s/#//" -e "/USE_SSL/s/#//" Modules/Setup.dist
    ./configure --enable-unicode=ucs4 --enable-shared --prefix=$HOME 2>&1 > configuring.log
    make 2>&1 > making.log || exit
    make install 2>&1 > installing.log || exit
    cd ..
    wget http://bootstrap.pypa.io/ez_setup.py | $HOME/bin/python - --user
    pip install ipython
    easy_install-2.7 pudb 
fi

#rm -rf $DOWN
