#! /bin/bash

find_python () {
    [[ -n $PYTHON && -x "$PYTHON" ]] && return 0
    [[ -n $PYTHON ]] && PYTHON=
    MY_PATH=$JAB/bin:$HOME/bin:/usr/local/bin:/usr/bin
    [[ -n $VIRTUAL_ENV ]] && MY_PATH=$VIRTUAL_ENV/bin:$MY_PATH
    PYTHON=$(PATH=$MY_PATH which python2.7 2>/dev/null)
    [[ -z $PYTHON ]] && PYTHON=$(which python2.7 2>/dev/null)
    [[ -z $PYTHON ]] && PYTHON=no_python
    export PYTHON
    [[ $PYTHON != no_python ]]
}

find_python

_has_ext () {
    [[ -n $(ls ${2:-.}/*.$1 2>/dev/null | grep -v -e fred -e log  | head -n 1) ]]
}

_has_py () {
    _has_ext py "$@"
}

_try="$_JAB_SRC_PYTHON_DIR/testing/try.py"
[[ -f "$_try" ]] || _try=no_file_try_py
export TRY=$_try

_home_src_python_dir=~/src/python
[[ -d "$_home_src_python_dir" ]] || _home_src_python_dir=no_dir_home_src_python

_expected=$JAB/environ.d/jab.sh; _actual="No $(basename $_expected)."; [[ -f "$_expected" ]] && _actual=$_expected;source_path $_actual
source_path $JAB/bin/add_to_a_path.sh

[[ -z $PYTHONPATH ]] && suffix= || suffix=:$PYTHONPATH

export HOME_PYTHON=$_home_src_python_dir
_has_py $HOME_PYTHON && add_to_a_path _SRC_PYTHON_PATH $HOME_PYTHON
_has_py $JAB/src/python && add_to_a_path _SRC_PYTHON_PATH $JAB/src/python
export PYTHON_SOURCE_PATH=$JAB/src/python:$HOME_PYTHON
PYTHON_HOME=${HOME_PYTHON:-$JAB/src/python}
[[ -f "$PYTHON_HOME/pythonrc.py" ]] && export PYTHONSTARTUP=$PYTHON_HOME/pythonrc.py
export PYTHON_HOME
