#! /bin/cat

Welcome_to $BASH_SOURCE

_KEYBOARD_DIR=~/bash/keyboard

for _script in $(ls $_KEYBOARD_DIR/*.sh); do
    [[ $(readlink -f $BASH_SOURCE) == $(readlink -f $_script) ]] && continue
    . $_script
done

vim_keyboard () {
    local _files= _key= _options=
    for _key in "$@"; do
        local _path=$_KEYBOARD_DIR/$_key
        [[ -f ${_path} ]] && _file=${_path}
        [[ -f ${_path}.sh ]] && _file=${_path}.sh
        [[ -f $_file ]] && _files="$_files $_file" || _options="$_options $key"
    done
    [[ $_files ]] || _files=.
    vim -p $_files $_options
    . $_KEYBOARD_DIR/__init__.sh
}

Bye_from $BASH_SOURCE
