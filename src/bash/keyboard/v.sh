#! /bin/cat


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

# x

v () {
    [[ -z $1 ]] && vim_none || vim_some "$@"
}

# xx

v. () {
    v .
}

vb () {
    vim -p "$@"
}

vc () {
    # https://www.reddit.com/r/vim/comments/53mhut/using_vim_like_awk/d7ude9m
    vim - -u NONE -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
}

vd () {
    vim_diff "$1" "$2" "$3" -O
}

vu () {
    __doc__="Edit vim files in ~/jab. Add home vim files if different"
    local _vimrc="~/jab/vim/vimrc"; diff -q ~/.vimrc $_vimrc || _vimrc="~/.vimrc $_vimrc"
    local _vim="~/jab/vim/vimrc"; diff -qr ~/.vim $_vim >/dev/null || _vim="~/.vim $_vim"
    vim -p $_vimrc $_vim
}

vv () {
    local __doc__="Edit vim files"
    [[ -z $* ]] && vvu || vvv "$@"
}

# xxx

vin () {
    vim -c "setlocal buftype=nofile bufhidden=hide noswapfile" -
}

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
# xxxx

hd12 () {
    hd ~/tmp/one ~/tmp/two
}

vd12 () {
    vd ~/tmp/one ~/tmp/two
}

vd13 () {
    vd ~/tmp/one ~/tmp/three
}

vd23 () {
    vd ~/tmp/two ~/tmp/three
}
# xxxxx

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
# xxxxxx
# xxxxxxx
# xxxxxxxx

vd123 () {
    vd ~/tmp/one ~/tmp/two ~/tmp/three
}

# xxxxx
vim_none () {
    (echo "" > ~/tmp/fred
    $EDITOR ~/tmp/fred)
}

vim_some () {
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
}
