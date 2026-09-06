#! /bin/cat


ENVIRON_DIR=~/jab/environ.d
# echo ~/jab/environ.d/jab.sh
. $ENVIRON_DIR/jab.sh
# echo ~/jab/environ.d/environ.sh
. $ENVIRON_DIR/environ.sh
# echo ~/jab/environ.d/colour.sh
. $ENVIRON_DIR/colour.sh
# echo ~/jab/environ.d/python.sh
. $ENVIRON_DIR/python.sh
# echo ~/jab/environ.d/company.sh
. $ENVIRON_DIR/company.sh 2>/dev/null
# echo ~/jab/environ.d/ssh_completion.sh
. $ENVIRON_DIR/ssh_completion.sh
# echo ~/jab/environ.d/travis.sh
. $ENVIRON_DIR/travis.sh

. "$HOME/.cargo/env"
