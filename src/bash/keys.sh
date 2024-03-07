#! /bin/cat

keyboard_path () {
    # echo ~/bash/keyboard/$1
    echo /opt/clones/github/jalanb/jabs/jab/src/bash/keyboard/$1
}

key_exists () {
    local script_=
    for script_ in $(keyboard_path $1); do
        quietly test -f "$script_" && return 0
    done
    return 5
}

path_to_key () {
    local script_="${1%.sh}.sh"
    echo $(keyboard_path $script_)
}

ls_path_to_key () {
    quietly ls $(path_to_key $1)
}

echo_key () {
    [[ $1 ]] || return 4
    local script_=$(path_to_key $1)
    echo $script_
}

echo_keys () {
    [[ $@ ]] || return 0
    (
        command cd $(keyboard_path)
        for arg_ in $(quietly ls $@); do
            [[ $arg_ =~ __init__ ]] && continue
            [[ $arg_ ]] || continue
            ls $arg_
        done
    )
}

key_scripts () {
    (
        command cd $(keyboard_path)
        readlink -f $(echo_keys [a-z12].sh)
    )
}

key_init () {
    path_to_key __init__
}

same_path () {
    [[ $2 ]] || return 4
    [[ $1 ]] || return 8
    [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

keys_write () {
    local init_=$(key_init)
    echo "#! /usr/bin/env bat -l bash" > $init_
    for script_ in $(key_scripts); do
        grep -v "^#! " $script_ >> $init_
    done
}

keys_read () {
    keys_write
    . $(key_init)
}

keys_vim () {
    local init_=$(key_init) files_=
    if [[ ! "$@" ]]; then
        files_="$(key_scripts)"
        vv $files_
        return
    fi
    local option_= path_= file_=
    dir_=$(keyboard_path)
    for option_ in "$@"; do
        path_=$dir_/$option_
        [[ -f ${path_} ]] && file_=${path_}
        [[ -f ${path_}.sh ]] && file_=${path_}.sh
        [[ -f $file_ ]] && files_="$files_ $file_"
        file_=
    done
    [[ $files_ ]] || return 6
    vim -p $files_
    keys_read
}

keys_read
