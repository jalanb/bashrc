
recover () {
    local swap_file="$2"
    local text_file="$1"
    local _red="\033[0;31m"
    local _green="\033[0;32m"
    local _off="\033[0m"
    read -n1 -p "Recover $args (${_green}y${_off}/${_red}N${_off}) ? " reply
    if [[ yY =~ $reply ]]; then
        echo "Recovering $swap_file"
        recovered_file="${text_file}.recovered"
        #
        # I use the "g:recovering" variable within vim to
        #   prevent opening of extra tabs, YMMV
        #
        local editor=${VIM:-$EDITOR}
        $editor -r "$text_file" --cmd ":let g:recovering=1" -c"|:wq! ${recovered_file}" > ~/bash/fd/1 2> ~/bash/fd/2
        /bin/rm -i "$swap_file"
        if [[ -f "$recovered_file" ]]
        then
            if ! diff -q "$text_file" "$recovered_file"
            then
                $editor -d "$text_file" "$recovered_file"
            fi
            read -n1 -p "Remove $recovered_file (${_red}Y${_off}/${_green}n${_off}) ? " reply
            if [[ -z $reply || yY =~ $reply ]]; then
                /bin/rm -fv "$recovered_file"
            fi
        fi
        return 0
    else
        return 1
    fi
}

pre_vimming () {
    local _file="$1"
    local _swap_file="$2"
    echo "A swap file exists: $_swap_file"
    recover "$_file" "$_swap_file"
}

post_vimming () {
#
# This function is called after editting, arguments are same as vim got
#
    local arg= end_options=
    for arg in "$@"
    do
        [[ $arg == "--" ]] && end_options="--"
        [[ -e "$arg" ]] && ls -l $end_options "$arg"
    done
}
