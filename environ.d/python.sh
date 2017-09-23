#! /bin/bash

Welcome_to $BASH_SOURCE

# [[ -n $WELCOME_BYE ]] && echo 1
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

# [[ -n $WELCOME_BYE ]] && echo 2
find_python

# [[ -n $WELCOME_BYE ]] && echo 3
_has_ext () {
    [[ -d $2 ]] && [[ -n $(ls ${2:-.}/*.$1 2>/dev/null | grep -v -e fred -e log  | head -n 1) ]]
}

# [[ -n $WELCOME_BYE ]] && echo 4
_has_py () {
    _has_ext py "$@"
}

# [[ -n $WELCOME_BYE ]] && echo 5
_try="~/jab/src/python/testing/try.py"
[[ -f "$_try" ]] || _try=no_file_try_py
export TRY=$_try

# [[ -n $WELCOME_BYE ]] && echo 6
source_path ~/jab/environ.d/jab.sh
source_path ~/jab/src/bash/add_to_a_path.sh

# [[ -n $WELCOME_BYE ]] && echo 7
[[ -z $PYTHONPATH ]] && suffix= || suffix=:$PYTHONPATH
export PYTHONPATH=~/jab/src/python/site$suffix

export PYTHON_SOURCE_PATH=~/jab/src/python:~/src/python
[[ -f "~/jab/src/python/pythonrc.py" ]] && export PYTHONSTARTUP=~/jab/src/python/pythonrc.py

# [[ -n $WELCOME_BYE ]] && echo 8
_upgrade_package () {
    [[ -n $WELCOME_BYE ]] && echo Welcome to _upgrade_package "$@"
    bg pip2 install --upgrade --retries=1 "$@" 2>&1 >/dev/null 2>&1
    [[ -n $WELCOME_BYE ]] && echo Bye from _upgrade_package "$@"
}

# [[ -n $WELCOME_BYE ]] && echo 9
upgrades () {
    # [[ -n $WELCOME_BYE ]] && echo 9.1
    _upgrade_package pip
    # [[ -n $WELCOME_BYE ]] && echo 9.2
    _upgrade_package dotsite
    # [[ -n $WELCOME_BYE ]] && echo 9.0
}

# [[ -n $WELCOME_BYE ]] && echo 0
upgrades

Bye_from $BASH_SOURCE
