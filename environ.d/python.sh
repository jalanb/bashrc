#! /bin/bash

find_python () {
    [[ -n $PYTHON && -x "$PYTHON" ]] && return 0
    [[ -n $PYTHON ]] && PYTHON=
    MY_PATH=~/jab/bin:$HOME/bin:/usr/local/bin:/usr/bin
    [[ -n $VIRTUAL_ENV ]] && MY_PATH=$VIRTUAL_ENV/bin:$MY_PATH
    PYTHON=$(PATH=$MY_PATH which python2.7 2>/dev/null)
    [[ -z $PYTHON ]] && PYTHON=$(which python2.7 2>/dev/null)
    [[ -z $PYTHON ]] && PYTHON=no_python
    export PYTHON
    [[ $PYTHON != no_python ]]
}

find_python

_has_ext () {
    [[ -d $2 ]] && [[ -n $(ls ${2:-.}/*.$1 2>/dev/null | grep -v -e fred -e log  | head -n 1) ]]
}

_has_py () {
    _has_ext py "$@"
}


_try="~/jab/src/python/testing/try.py"
[[ -f "$_try" ]] || _try=no_file_try_py
export TRY=$_try

source_path ~/jab/environ.d/jab.sh
source_path ~/jab/bin/add_to_a_path.sh

[[ -z $PYTHONPATH ]] && suffix= || suffix=:$PYTHONPATH
export PYTHONPATH=~/jab/src/python/site$suffix

export PYTHON_SOURCE_PATH=~/jab/src/python:~/src/python
[[ -f "~/jab/src/python/pythonrc.py" ]] && export PYTHONSTARTUP=~/jab/src/python/pythonrc.py

_upgrade_package () {
    pip install --upgrade "$@" 2>&1 | grep -v "Requirement already up-to-date"
}

upgrades () {
    _upgrade_package pip
    _upgrade_package dotsite
}

upgrades
