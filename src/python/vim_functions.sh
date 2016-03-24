
recover () {
    local _swap_file="$2"
    local _text_file="$1"
    read -p "Recover $_text_file ? " reply
    if [[ -z $reply || $reply == "y" || $reply == "Y" ]]; then
        echo "Recovering $_swap_file"
        recovered_file="${_text_file}.recovered"
        #
        # I use the "g:recovering" variable within vim to
        #   prevent opening of extra tabs, YMMV
        #
        local editor=${VIM:-$EDITOR}
        $editor -r "$_text_file" --cmd ":let g:recovering=1" -c"|:wq! ${recovered_file}" >/dev/null 2>&1
        /bin/rm -i "$_swap_file"
        if [[ -f "$recovered_file" ]]
        then
            if ! diff -q "$_text_file" "$recovered_file"
            then
                $editor -d "$_text_file" "$recovered_file"
            fi
            /bin/rm -i "$recovered_file"
        fi
        return 0
    else
        return 1
    fi
}

pre_vimming () {
    local _file="$1"
    local _swap_file="$2"
    ls -l "$_swap_file"
    recover "$_file" "$_swap_file"
}

post_vimming () {
#
# This function is called after editting, arguments are same as vim got
#
    local arg
    local end_options=
    for arg in "$@"
    do
        [[ $arg == "--" ]] && end_options="--"
        [[ -e "$arg" ]] && ls -l $end_options "$arg"
    done
}
