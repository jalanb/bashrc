#! /bin/cat


key_path () {
    echo ~/bash/keyboard/$1
}

echo_key () {
    local files_=$(ls $(key_path $1) 2>/dev/null) || return 1
    echo -n  $files_
}

echo_keys () {
    local arg_= args_="$@"
    [[ ! "$@" ]] && echo_key || for arg_ in "$args_"; do echo_key $arg_; done
    echo
}

is_key_script () {
    [[ -f $(echo_keys $1) ]]
}

key_script () {
    is_key_script $1 || return 1
    echo_keys $1
}

key_scripts () {
    ls $(echo_keys '[a-z12].sh')
}

key_init () {
    echo $(key_path __init__.sh)
}

same_path () {
    [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

is_init () {
    same_path "$1" $(key_init)
}

write_keys () {
    local init_=$(key_init)
    echo "#! /usr/bin/env bat -l bash" > $init_
    for script_ in $(key_scripts); do
        grep -v "^#! " $script_ >> $init_
    done
}

read_keys () {
    write_keys
    . $(key_init)
}

vim_keys () {
    local init_=$(key_init) files_=
    if [[ ! "$@" ]]; then
        files_="$(echo_keys '[a-z12].sh')"
        vv $files_
        return
    fi
    local option_= path_= file_=
    dir_=$(key_path)
    for option_ in "$@"; do
        path_=$dir_/$option_
        [[ -f ${path_} ]] && file_=${path_}
        [[ -f ${path_}.sh ]] && file_=${path_}.sh
        [[ -f $file_ ]] && files_="$files_ $file_"
        file_=
    done
    vim -p $files_
    read_keys
}

read_keys
