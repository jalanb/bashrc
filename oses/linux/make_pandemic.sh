#! /bin/bash

set -e

get_pandemic () {
    cd ~/hub
    git clone https://github.com/jwcxz/vim-pandemic.git
}

make_pandemic () {
    cd vim-pandemic
    sed -i -e "s|vim/bundle.remote|vim/bundle|" bin/pandemic
    python2 setup.py install --prefix=$HOME
}

update_pandemic () {
    pandemic list | sed -e "s/:.*//" | xargs env GIT_SSL_NO_VERIFY=true pandemic update
}

main () {
    get_pandemic
    make_pandemic
    # update_pandemic
}


main
