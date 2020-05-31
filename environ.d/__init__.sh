#! /bin/cat


ENVIRON_DIR=~/jab/environ.d
. $ENVIRON_DIR/jab.sh
. $ENVIRON_DIR/environ.sh
. $ENVIRON_DIR/colour.sh
. $ENVIRON_DIR/python.sh
. $ENVIRON_DIR/company.sh 2>/dev/null
. $ENVIRON_DIR/ssh_completion.sh
. $ENVIRON_DIR/travis.sh

Bye_from $BASH_SOURCE
