#! /bin/bash



export PIP_REQUIRE_VIRTUALENV=false
export PIP_RESPECT_VIRTUALENV=true

# type add_to_a_path >/dev/null 2>&1 || . ~/bash/add_to_a_path.sh

# add_to_a_path PYTHONPATH ~/jab/src/python/site
export PYTHONPATH=$HOME/jab/src/python/site
# add_to_a_path PYTHON_SOURCE_PATH ~/jab/src/python
export PYTHON_SOURCE_PATH=$HOME/jab/src/python
[[ -f ~/jab/src/python/pythonrc.py ]] && export PYTHONSTARTUP=~/jab/src/python/pythonrc.py


export PYTHONBREAKPOINT="pudb.set_trace"
