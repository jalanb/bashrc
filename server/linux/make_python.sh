#! /bin/bash

set -e


MINIMUM_VERSION=2.7.10

install_home_python () {
    if [[ -f "~/Downloads/Python-${MINIMUM_VERSION}.tgz" ]]; then
        cp ~/Downloads/Python-${MINIMUM_VERSION}.tgz .
    else
        wget http://www.python.org/ftp/python/${MINIMUM_VERSION}/Python-${MINIMUM_VERSION}.tgz
    fi
    tar zxf Python-${MINIMUM_VERSION}.tgz
    cd Python-${MINIMUM_VERSION}
    sed -i -e "s|#SSL=/usr/local/ssl|SSL=/usr/local/ssl|" -e "s|^#_ssl|_ssl|" -e "/lssl/s/#//" -e "/USE_SSL/s/#//" Modules/Setup.dist
    ./configure --enable-shared --prefix=$HOME 2>&1 > configuring.log
    make 2>&1 > making.log || exit
    make install 2>&1 > installing.log || exit
    cd $HOME/bin
    mv python${MINIMUM_VERSION%.*} python${MINIMUM_VERSION}
    echo -e "#! /bin/bash\n\nPYTHONPATH=\$HOME/lib/python${MINIMUM_VERSION%.*}:\$PYTHONPATH LD_LIBRARY_PATH=\$HOME/lib \$HOME/bin/python$MINIMUM_VERSION \"\$@\"" > python${MINIMUM_VERSION%.*}
    cd ..
}

install_home_pip () {
    wget https://bootstrap.pypa.io/get-pip.py
    $HOME/bin/python get-pip.py --user
    rm -rf get-pip.py
}

pip_install_modules () {
    PIP=$HOME/bin/pip
    [[ -x "$PIP" ]] || PIP=$HOME/.local/bin/pip
    if [[ ! -x "$PIP" ]]; then
        echo >&2 Cannot find pip
        return 1
    fi
    $PIP install setuptools
    $PIP install -r $BASH_DIR/requirements.txt
}

main () {
    if ! python -c "import sys; from distutils.version import LooseVersion as ver; sys.exit(int(ver(sys.version.split()[0]) < ver('"$MINIMUM_VERSION"')))"; then
        install_home_python
        install_home_pip
        pip_install_modules
    fi
}

. ~/jab/src/bash/scratch.sh

scratch_up
main
scratch_down
