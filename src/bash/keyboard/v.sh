#! /bin/cat


old_v () {
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

# =======
# v () {
#     vim -p "$@"
# }
# 
# 
# vv () {
#     local __doc__="Edit vim files"
#     [[ -n $* ]] && vu || vva "$@"
# }
# 
# vvv () {
#     [[ -n $* ]] && vva "$@" || vva .
# }
# 
# >>>>>>> l and v join the initially elusive scripts

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
    [[ -z $* ]] && vvu || vvv "$@"
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
    local _vimrc="$HOME/jab/vim/vimrc"; diff -q $HOME/.vimrc $_vimrc || _vimrc="$HOME/.vimrc $_vimrc"
    local _vim="$HOME/jab/vim"; diff -qr $HOME/.vim $_vim >/dev/null || _vim="$HOME/.vim $_vim"
    vvv $_vimrc $_vim "$@"
}

vvv () {
    (cd ~/jab/vim
    vim -p "$@"
    gsi)
}
