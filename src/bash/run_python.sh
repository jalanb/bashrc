#! /bin/cat

Welcome_to $BASH_SOURCE


pypath () {
    local _my_path="$HOME/bin:/usr/local/bin:/usr/bin"
    local _venv_bin="${VIRTUAL_ENV:-xxx}"/bin
    [[ -d $_venv_bin ]] && _my_path="$_venv_bin:$_my_path"
    (PATH=$_my_path "$@")
}

Bye_from $BASH_SOURCE
