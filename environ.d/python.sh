#! /bin/bash



export PIP_REQUIRE_VIRTUALENV=false
export PIP_RESPECT_VIRTUALENV=true

_try="$HOME/jab/src/python/testing/try.py"
[[ -f "$_try" ]] || _try=no_file_try_py
export TRY=$_try


type add_to_a_path >/dev/null 2>&1 || . ~/bash/add_to_a_path.sh

add_to_a_path PYTHONPATH ~/jab/src/python/site
add_to_a_path PYTHON_SOURCE_PATH ~/jab/src/python
[[ -f ~/jab/src/python/pythonrc.py ]] && export PYTHONSTARTUP=~/jab/src/python/pythonrc.py


export PYTHONBREAKPOINT="pudb.set_trace"
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi
