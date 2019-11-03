#! /bin/cat


# x

v () {
    vim -p "$@"
}

# v () {
#     [[ -z $1 ]] && vim_none || vim_some "$@"
# }
# 
# xx

v. () {
    v .
}

# va

vb () {
    vim -p "$@"
}

vc () {
    local _files=
    [[ -f .cd ]] && _files=.cd
    v $_files $CDE.sh ~/hub/cde "$@"
}

vd () {
    vim_diff "$1" "$2" "$3" -O
}

# ve
# vf

vj () {
    (cd ~/jab; v. gsi)
}

vk () {
    vim -p ~/keys "$@"
}

vo () {
    local _command=$(history -p !-1)
    vim -p $($_command 2>/dev/null)
}

vr () {
    local _command=$(history -p !-1)
    vim -p $($_command >/dev/null)
}

vq () {
    vim -p "$@"
}

vt () {
    pyth ~/jab/src/python/vim_traceback.py "$@"
}

vu () {
    __doc__="Edit vim files in ~/jab. Add home vim files if different"
    local _vimrc="~/jab/vim/vimrc"; diff -q ~/.vimrc $_vimrc || _vimrc="~/.vimrc $_vimrc"
    local _vim="~/jab/vim/vimrc"; diff -qr ~/.vim $_vim >/dev/null || _vim="~/.vim $_vim"
    vim -p $_vimrc $_vim
}

vv () {
    v ~/.vimrc "$@"
}

vw () {
    v $WHYP.sh "$@"
}

# vv () {
#     local __doc__="""Edit vim files"""
#     [[ -z $* ]] && vvu || vvv "$@"
# }

vy () {
    v $(ls *.py | grep -v '__*.py*')
}

# xxx

VIM () {
    sudo vim -p "$@"
}

# vaf

vat () {
    vimcat "$@"
}

vd1 () {
    vd ~/one "$@"
}

vdd () {
    local _vim_mark=_vim_
    local _vim_files=$(find . -type f -name "*$_vim_mark")
    for _vim_file in $_vim_files; do
        _vim_rlf=$(readlink -f $_vim_file)
        _vim_dir=$(dirname_ $_vim_rlf)

        _vim_name=$(basename_ $_vim_rlf)
        _vim_stem="${_vim_name/$_vim_mark/}"
        _vim_back="${_vim_stem}$_vim_mark"
        # echo "file: $_vim_file"
        # echo "readlink: $_vim_rlf"
        # echo "name: $_vim_name"
        # echo "stem: $_vim_stem"
        # echo "back: $_vim_back"
        # echo "dir: $_vim_dir"

        [[ -d "$_vim_dir" ]] || echo "not -d $_vim_dir"
        [[ -d "$_vim_dir" ]] || continue

        (
        # echo "cd $_vim_dir"
            cd $_vim_dir
            if [[ -f "$_vim_stem" ]]; then
                ls -l "$_vim_stem"
                if [[ -f "$_vim_back" ]]; then
                    ls -l "$_vim_back"
                    vd $_vim_back $_vim_stem
                    rri $_vim_back
                # else
                    # echo "not -f $_vim_back"
                fi
            # else
                # echo "not -f $_vim_stem"
            fi
        )
        echo
    done
}

vdf () {
    [[ -f ~/tmp/fred.vim ]] && vd ~/tmp/fred.vim "$1"
}

ved () {
    # https://www.reddit.com/r/vim/comments/53mhut/using_vim_like_awk/d7ude9m
    vim - -u NONE -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
}

vfd () {
    vim -p $(fd "$@")
}

vin () {
    vim -c "setlocal buftype=nofile bufhidden=hide noswapfile" -
}

vlo () {
    v_safely $(locate "$@")
}

vtc () {
    vtr -c
}

vtr () {
    python ~/jab/src/python/tracebacks.py -e "$@"
}

vtt () {
    local _crappy_program_py=$1
    python _crappy_program_py | python ~/jab/src/python/vim_traceback.py
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
    vim -p . "$@"
    gsi)
}

# xxxx

hd12 () {
    hd ~/one ~/two
}

vd12 () {
    vd ~/one ~/two
}

vd13 () {
    vd ~/one ~/three
}

vd23 () {
    vd ~/two ~/three
}

vims () {
    whiches vim
}

vini () {
    vim -p $(find $( rlf ~/jab ) -name __init__.sh | lines_to_spaces)
}

vvpj () {
    vvf python/jab.vim
}

# xxxxx

old_v () {
    if [[ -z $* ]]; then
        echo "" > ~/tmp/fred
        $EDITOR ~/tmp/fred
    else
        script=$(pyth ~/jab/src/python/vim.py "$@")
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
                pyth ~/jab/src/python/vim.py -U "$@"
            fi
        else
            echo Python error: $status
            if [[ -n $script ]]; then
                echo Script produced you could run it with
                echo "  bash $script"
                echo or debug the problem with
                echo "  pyth ~/jab/src/python/vim.py -U" "$@"
            else
                echo No script produced please try
                echo pyth ~/jab/src/python/vim.py -U "$@"
            fi
        fi
    fi
}
# xxxxxx

v_safely () {
    local __doc__="""Use a safe vim function"""
    vim -p "$@"
}

# xxxxxxx
# xxxxxxxx

vd123 () {
    vd ~/one ~/two ~/three
}

# xxxxx
vim_none () {
    (echo "" > ~/tmp/fred
    $EDITOR ~/tmp/fred)
}

vim_some () {
    script=$(pyth ~/jab/src/python/vim.py "$@")
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
            pyth ~/jab/src/python/vim.py -U "$@"
        fi
    else
        echo Python error: $status
        if [[ -n $script ]]; then
            echo Script produced you could run it with
            echo "  bash $script"
            echo or debug the problem with
            echo "  pyth ~/jab/src/python/vim.py -U" "$@"
        else
            echo No script produced please try
            echo pyth ~/jab/src/python/vim.py -U "$@"
        fi
    fi
}

_vim_recover () {
    [[ -f ~/tmp/fred.vim ]] && vd ~/tmp/fred.vim ~/bash/functons.sh
}
