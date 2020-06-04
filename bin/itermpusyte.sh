#! /usr/bin/env bash

pudb_file=~/iterm.pudb # put your command in there
jabyte=~/jab/python/site/
pysyte=~/hub/pysyte

fred=
if [[ ! -f $pudb_file ]]; then
    fred=/tmp/fred.py
    echo "print('Hello World!')" > $fred
    echo "$fred" > $pudb_file
fi

source $pysyte/.venv/bin/activate
env
PYTHONPATH=$jabyte:$pysyte $pysyte/.venv/bin/pudb3 $(cat $pudb_file)
[[ $fred ]] && rm -f $fred $pudb_file

