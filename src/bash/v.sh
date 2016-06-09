#! /bin/cat

v () {
    if [[ -z $* ]]; then
        echo "" > ~/tmp/fred
        $EDITOR ~/tmp/fred
    else
        script=$(mython ~/jab/src/python/vim.py "$@")
        status=$?
        if [[ $status == 0 ]]; then
            if [[ -n $script ]]; then
                if [[ -f "$script" ]]; then
                    bash $script
                    #rr $script
                else
                    echo $script is not a file >&2
                fi
            else
                mython ~/jab/src/python/vim.py -U "$@"
            fi
        else
            echo Python error: $status
            if [[ -n $script ]]; then
                echo Script produced you could run it with
                echo "  bash $script"
                echo or debug the problem with
                echo "  mython ~/jab/src/python/vim.py -U" "$@"
            else
                echo No script produced please try
                echo mython ~/jab/src/python/vim.py -U "$@"
            fi
        fi
    fi
}

# xx

vv () {
    [[ -n $* ]] && vvu || vvv "$@"
}

# xxx

vvb () {
    vvf sh.vim
}

vvf () {
    vvv ftplugin/$1
}

vvg () {
    gv ~/jab/vim/gvimrc
}

vvp () {
    vvf python
}

vvy () {
    vvf python/jab.vim
}


vvu () {
    __doc__="Edit ~/jab/vim files and ~/vim files if different"
    local _vimrc="~/jab/vim/vimrc"; diff -q ~/.vimrc $_vimrc || _vimrc="~/.vimrc $_vimrc"
    local _vim="~/jab/vim/vimrc"; diff -qr ~/.vim $_vim >/dev/null || _vim="~/.vim $_vim"
    vvv $_vimrc $_vim "$@"
}

vvv () {
    (cd ~/jab/vim
    vim -p "$@"
    gsi)
}


