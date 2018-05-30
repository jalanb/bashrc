#! /bin/cat

Welcome_to $BASH_SOURCE


pyth () {
    local _python=python
    for _arg in "$@"; do
        [[ -f "$_arg" ]] || continue
        head -n 1 "$_arg" | grep -q '#!.*python' || continue
        _python=$(head -n 1 "$_arg" | sed -e "s:.* ::")
        break
    done
    pypath $_python "$@"
}

pypath () {
    local _my_path="$HOME/bin:/usr/local/bin:/usr/bin"
    local _venv_bin="${VIRTUAL_ENV:-xxx}"/bin
    [[ -d $_venv_bin ]] && _my_path="$_venv_bin:$_my_path"
    (PATH=$_my_path "$@")
}

Bye_from $BASH_SOURCE
