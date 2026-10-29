#! /bin/bash

export PIP_REQUIRE_VIRTUALENV=false
export PIP_RESPECT_VIRTUALENV=true

export PYTHONPATH=$HOME/jab/src/python/site
export PYTHON_SOURCE_PATH=$HOME/jab/src/python
export PYTHONBREAKPOINT="pudb.set_trace"

[[ -f ~/jab/src/python/pythonrc.py ]] && export PYTHONSTARTUP=~/jab/src/python/pythonrc.py
