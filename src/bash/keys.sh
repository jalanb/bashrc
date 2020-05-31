#! /bin/cat


_KEYBOARD_DIR=~/bash/keyboard

source_keyboard () {
    for _script in $(ls $_KEYBOARD_DIR/*.sh); do
        . $_script
    done
}


vim_keyboard () {
    local _files= _key= _options=
    if [[ ! "$@" ]]; then
        vim $_KEYBOARD_DIR
        return $?
    fi
    for _key in "$@"; do
        local _path=$_KEYBOARD_DIR/$_key
        [[ -f ${_path} ]] && _file=${_path}
        [[ -f ${_path}.sh ]] && _file=${_path}.sh
        [[ -f $_file ]] && _files="$_files $_file" || _options="$_options $key"
    done
    [[ $_files ]] || _files=.
    vim -p $_files $_options
    source_keyboard
}

source_keyboard

alias vk=vim_keyboard
alias sk=source_keyboard

Bye_from $BASH_SOURCE
