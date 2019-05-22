#! /bin/bash

set -e

link_to () {
    [[ -h $2 ]] || ln -s $1 $2
}

link_to_config () {
    for source_dir in $(find ~/jab/etc/config -type d)
    do
        dest_dir=$(echo $source_dir | sed -e "s:~/jab/etc/config:$HOME/.config:")
        [[ ! -e "$dest_dir" ]] && mkdir -p $dest_dir
    done
    for source_file in $(find ~/jab/etc/config -type f)
    do
        dest_link=$(echo $source_file | sed -e "s:~/jab/etc/config:$HOME/.config:")
        if [[ -L $dest_link ]]; then
            source_link=$(realpath $dest_link)
            if [[ $source_link != $source_file ]]; then
                "$dest_link is linked to $source_link (not $source_file)" >&2
            fi
        elif [[ -e "$dest_link" ]]; then
            echo "$dest_link exists and is not a link" >&2
        else
            dest_dir=$(dirname_ $dest_link)
            if [[ -d "$dest_dir" ]]; then ln -s $source_file $dest_link
            else echo "$dest_dir is not a directory (for $dest_link)" >&2
            fi
        fi
    done
}

link_to_ipython () {
    local parent=$HOME/.ipython
    [[ -d "$parent" ]] || mkdir -p $parent
    link_to ~/jab/ipython/$1 $parent/$1
}

link_to_home () {
    local from=~/jab/$1
    local to=$HOME/.$(basename_ $1)
    [[ -e "$to" ]] && rm -rf $to
    if [[ -e "$from" ]]; then
        link_to $from $to
    else
        echo $from does not exist >&2
    fi
}

link_bashrc () {
    local _bashrc=~/jab/src/bash/bashrc
    if [[ -f $_bashrc ]]; then
        [[ -d ~/old ]] || mkdir ~/old
        mv ~/.bashrc old
        ln -s $_bashrc ~/.bashrc
    fi
}

main () {
    if [[ ! -e ~/jab ]]; then
        local _this_dir=$(dirname $(readlink -f $BASH_SOURCE))
        local _top_level=$(git -C "$_this_dir" rev-parse --show-toplevel)
        (cd ~; ln -s $_top_level jab)
    fi
    [[ -d ~/.vim ]] && rm -rf ~/.vim
    link_to_home vim
    link_to_home vim/vimrc
    link_to_home vim/gvimrc
    link_to_home etc/editrc
    link_to_home etc/inputrc
    link_to_home src/python/pythonrc.py
    link_to_home etc/dir_colors
    link_to_home etc/ackrc
    link_to_home etc/gitconfig
    link_to_home etc/gitignore_global
    link_to_home etc/tmux.conf
    link_to_ipython config_helper_functions.py
    link_to_ipython ipy_user_conf.py
    link_to_ipython ipythonrc
    link_to_ipython options.conf
    link_to_ipython ipy_profile_company.py
    link_to_config
}


main "$@"
