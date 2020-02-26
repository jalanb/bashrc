#! /usr/bin/env bash

pudb_file=~/iterm.pudb # put your command in there
mysyte=~/jab/python/site/
pysyte=~/hub/pysyte

fred=
if [[ ! -f $pudb_file ]]; then
    fred=/tmp/fred.py
    echo "print('Hello World!')" > $fred
    echo "$fred" > $pudb_file
fi

source ~/jab/.venv/bin/activate
env
PYTHONPATH=$mysyte:$pysyte ~/jab/.venv/bin/pudb3 $(cat $pudb_file)
[[ $fred ]] && rm -f $fred $pudb_file
