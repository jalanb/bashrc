#! /bin/bash

BASH_DIR=$(dirname $(/usr/local/bin/readlink -m $BASH_SOURCE))
PYTHON_DIR=$(python -c"import os; print os.path.realpath(\"$BASH_DIR\")" | sed -e "s/python.*/python/")
export PYTHONPATH=$PYTHON_DIR/site
/usr/local/bin/python $BASH_DIR/pp.py "$@"
