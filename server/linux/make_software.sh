#! /bin/bash

BASH_DIR=$(dirname $BASH_SOURCE)
bash $BASH_DIR/make_which.sh
bash $BASH_DIR/make_tree.sh
bash $BASH_DIR/make_python.sh

