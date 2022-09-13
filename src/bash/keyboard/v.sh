#! /bin/cat

. ~/keys/m.sh

# x

unalias v >/dev/null 2>&1
v () {
    mvim "$@"
}

# xx

hd () {
    vim_diff -o "$@"
}

v. () {
    vv .
}

va () {
    _edit_source $(aliases) "$@"
}

vc () {
    local _dot_cd
    [[ -f .cd ]] && _dot_cd=.cd
    v ~/cde.sh ~/cde/ ~/keys/c.sh $_dot_cd
}

vd () {
    vim_diff -O "$@"
}

ve () {
    _edit_source ~/jab/environ.d/jab.sh "$@"
}

vf () {
    _edit_source $(functons) "$@"
}

vg () {
    local user_=$(readlink -f ~/.gitconfig 2>/dev/null) clone_=.git/config
    [[ -f $user_ ]] || user_=
    [[ -f $clone_ ]] || clone_=
    if [[ $1 ]]; then
        vim -p $user_ $clone_ +/"$1"
    else
        vim -p $user_ $clone_
    fi
}

# vi

vj () {
    (cd ~/jab; mvim .; gsi)
}

# vk

vl () {
    local stdout_=$(history -p !-1)
    vim -p $($stdout_)
}

# vm
# vn
# vo
vp () {
    _edit_source ~/bash/prompt.sh +/^_colour_prompt
}

# vq
# vr
# vs

vt () {
    python ~/jab/src/python/vim_traceback.py "$@"
}

vu () {
    __doc__="Edit vim files in ~/jab. Add home vim files if different"
    local _vimrc="~/jab/vim/vimrc"; diff -q ~/.vimrc $_vimrc || _vimrc="~/.vimrc $_vimrc"
    local _vim="~/jab/vim/vimrc"; diff -qr ~/.vim $_vim >/dev/null || _vim="~/.vim $_vim"
    v $_vimrc $_vim
}

vv () {
    [[ $1 ]] && vim -p "$@" || vim ~/.vimrc
}

vw () {
    v ~/whyp.sh "$@"
}

# vx

vy () {
    v $(ls *.py | grep -v '__*.py*')
}

# vz

# xxx

VIM () {
    sudo vim -p "$@"
}

# vaf

vat () {
    vimcat "$@"
}


vbb () {
    (
        cd ~/jalanb/jab
        local local_=local/__init__.sh
        [[ -f $local_ ]] || local_=
        local files_="$HOME/.bashrc __init__.sh environ.d/__init__.sh src/bash/__init__.sh $local_ $HOME/.vimrc "
        vim -p $files_ "$@"
        readlink -f $files_
    )
}

vd1 () {
    vd ~/one "$@"
}

vd2 () {
    vd ~/two "$@"
}

vd3 () {
    vd ~/three "$@"
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

        [[ -d "$_vim_dir" ]] || echo "not -d $_vim_dir"
        [[ -d "$_vim_dir" ]] || continue
        (
            cd $_vim_dir
            [[ -f "$_vim_stem" ]] && ls -l "$_vim_stem"
            [[ -f "$_vim_back" ]] && ls -l "$_vim_back"
            [[ -f "$_vim_stem" && -f "$_vim_back" ]] || continue
            vd $_vim_back $_vim_stem
            rri $_vim_back
        )
        echo
    done
}

# Next 2 are from https://www.reddit.com/r/vim/comments/53mhut/using_vim_like_awk/d7ude9m
#     "Maybe credit /r/vim collectively. That seems reasonably safe"

ved () {
    local """Use vim ex commands in a pipe editor"""
    # echo "foo" | ved '%s,o,x,g' -> "fxx"
    [[ $* ]] || show_fail "Usage: ved <commands>" 
    [[ $* ]] || return 1
    vim - -u NONE -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
}

ven () {
    local """Use vim normal commands in a pipe editor"""
    # https://www.reddit.com/r/vim/comments/53mhut/using_vim_like_awk/d7ude9m
    # echo "hello world" | ven 'wdw' -> "hello "
    [[ $* ]] || show_fail "Usage: ven <commands>" 
    [[ $* ]] || return 1
    vim - -u NONE -es '+1' "+normal $*" '+%print' '+:qa!' | tail -n +2
}

vfd () {
    vim -p $(fd --follow "$@")
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

vss () {
    vim -p ~/.ssh/config ~/.ssh/keys/config ~/.ssh/macs ~/.ssh/ab13173
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
    v "$@" .
    gsi)
}

# xxxx

hd12 () {
    hd ~/one ~/two "$@"
}

vd12 () {
    vd ~/one ~/two "$@"
}

vd13 () {
    vd ~/two ~/three "$@"
}

vd21 () {
    vd ~/one ~/two "$@"
}

vd23 () {
    vd ~/two ~/three "$@"
}

vd32 () {
    vd ~/one ~/two "$@"
}

vd31 () {
    vd ~/two ~/three "$@"
}

vims () {
    whiches vim
}

vini () {
    v $(find $( rlf ~/jab ) -name __init__.sh | lines_to_spaces)
}

# xxxxx

vimpy () {
    if [[ -z $* ]]; then
        vim_none
        return 0
    fi
    local _script=$(python ~/jab/src/python/vim.py "$@")
    status=$?
    if [[ $status == 0 && -f "$_script" ]]; then
        bash $_script
        return $?
    fi
    [[ $status == 0 ]] || echo Python error: $status
    if [[ -f $_script ]]; then
        echo "Script produced, you could run it with"
        echo "    bash $_script"
        echo "or debug the problem with"
        echo "    pudb ~/jab/src/python/vim.py" "$@"
    else
        echo "No script produced please try"
        echo "    pudb ~/jab/src/python/vim.py" "$@"
    fi
    return 1
}

vd123 () {
    vd ~/one ~/two ~/three "$@"
}

# xxxxxx
# xxxxxxx
# xxxxxxxx

vim_diff () {
    local one_= two_= three_= diff_opts_= edit_opts_= arg_=
    [[ $1 =~ -[dD] ]] && diff_opts_=$1 && shift
    if [[ $1 =~ -[oO] ]]; then
        [[ $1 =~ -o ]] && diff_opts_=-do
        [[ $1 =~ -O ]] && diff_opts_=-dO
        shift
    fi
    [[ $diff_opts_ ]] || diff_opts_=-dO
    [[ $diff_opts_ =~ -[Dd] ]] || diff_opts_="-dO $diff_opts_"
    [[ -e "$1" ]] && one_="$1" && shift
    if [[ ! $one_ ]]; then 
        echo none >&2
        return 1
    fi
    [[ -e "$1" ]] && two_="$1" && shift
    [[ -e "$1" ]] && three_="$1" && shift
    if ! _any_diff "$one_ " "$two_" "$three_"; then
        echo same 
        return 1
    fi
    vim $diff_opts_ $one_  $two_ $three_"$@"
}

v_safely () {
    local __doc__="""Use a safe vim function"""
    vv "$@"
}


# v () {
#     [[ $1 ]] && vim_some "$@" || vim_none 
# }
#

vim_none () {
    (echo "" > ~/tmp/fred
    mvim ~/tmp/fred)
}

vim_some () {
    script=$(python ~/jab/src/python/vim.py "$@")
    status=$?
    if [[ $status == 0 ]]; then
        if [[ -n $script ]]; then
            if [[ -f "$script" ]]; then
                bash $script
                #rr $script
            else
                show_error $script is not a file
            fi
        else
            python ~/jab/src/python/vim.py -U "$@"
        fi
    else
        echo Python error: $status
        if [[ -n $script ]]; then
            echo Script produced you could run it with
            echo "  bash $script"
            echo or debug the problem with
            echo "  pudb ~/jab/src/python/vim.py" "$@"
        else
            echo No script produced please try
            echo pudb ~/jab/src/python/vim.py "$@"
        fi
    fi
}
