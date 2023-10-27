#! /bin/cat

. ~/keys/m.sh

# x

unalias v >/dev/null 2>&1
unalias vv >/dev/null 2>&1

v () {
    open /Applications/MacVim.app "$@"
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
    vim_cde ~/keys/c.sh
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
    local user_config_=$(readlink -f ~/.gitconfig 2>/dev/null) clone_config_="$(get_root)/.git/config"
    local user_ignore_=$(readlink -f ~/.gitignore_global 2>/dev/null) clone_ignore_="$(get_root)/.gitignore"
    [[ -f $user_config_ ]] || user_config_=
    [[ -f $clone_config_ ]] || clone_config_=
    [[ -f $user_ignore_ ]] || user_ignore_=
    [[ -f $clone_ignore_ ]] || clone_ignore_=
    if [[ $1 ]]; then
        vim -p $user_config_ $clone_config_ $user_ignore_ $clone_ignore_ +/"$1"
    else
        vim -p $user_config_ $clone_config_ $user_ignore_ $clone_ignore_
    fi
}

# vi

vj () {
    (cd ~/jab; vv .; gsi)
}

vl () {
    local stdout_=$(history -p !-1)
    vim -p $($stdout_)
}

# vm
# vn
# vo
vp () {
    _edit_source ~/bash/prompt.sh +/^colour_prompt "$@"
}

# vq
# vr
vs () {
    vv "$@"
    local arg_=
    for arg_ in "$@"; do
        [[ -f "$arg_" ]] || continue
        . "$arg_"
    done
}

vt () {
    python ~/jab/src/python/vim_traceback.py "$@"
}

vu () {
    __doc__="Edit vim files in ~/jab. Add home vim files if different"
    local _vimrc="$HOME/jab/vim/vimrc"; diff -q $HOME/.vimrc $_vimrc || _vimrc="$HOME/.vimrc $_vimrc"
    local _vim="$HOME/jab/vim/vimrc"; diff -qr $HOME/.vim $_vim >/dev/null || _vim="$HOME/.vim $_vim"
    v $_vimrc $_vim
}

vv () {
    local gsi_= source_=
    if [[ $1 =~ ^- ]]; then
        [[ $1 =~ -g ]] && gsi_=1
        [[ $1 =~ -s ]] && source_=1
        shift
    fi
    local dir_="$HOME"
    [[ -f $1 ]] && dir_=$(dirname $(readlink "$1"))
    [[ -d $1 ]] && dir_=$(basename $(readlink "$1"))
    [[ $* ]] && vim -p "$@" || vim -p ~/keys/v.sh ~/.vimrc
    [[ $gsi_ ]] && (cd $dir_; gsi)
    [[ $1 =~ [.]sh$ ]] || return 0
    [[ $source_ ]] && source "$@" 
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

vaf () {
    vim -p $(aliases) $(functons)
    sa
    sf
}

vat () {
    vimcat "$@"
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
    local __doc__="""Use vim ex commands in a pipe editor"""
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

vfg () {
    _sought="$1" && shift
    vf "$@" +/$_sought
}

vfh () {
    vim -p $( $( h1 ) | space_lines ) "$@"
}

vin () {
    vim -c "setlocal buftype=nofile bufhidden=hide noswapfile" -
}

vfr () {
    python ~/jab/src/python/vim_traceback.py "$@"
}

vgf () {
    _edit_source ~/bash/git/functons.sh  ~/.gitconfig "$@"
}


vla () {
    _edit_locals aliases.sh "$@"
}

vle () {
    _edit_locals environ.sh "$@"
}

vlf () {
    _edit_locals functons.sh "$@"
}

vla () {
    _edit_locals aliases.sh "$@"
}

vlo () {
    vv $(locate "$@")
}

vpe () {
    _edit_source ~/jab/environ.d/python
}

vpr () {
    local _crappy_program_py=$1
    python _crappy_program_py | python ~/jab/src/python/vim_traceback.py
}

vss () {
    local files_= file_=
    for file_ in ~/.ssh/config ~/.ssh/keys/config ~/.ssh/macs ~/.ssh/ab13173 ~/.ssh/jab; do
        [[ -f $file_ ]] || continue
        files_="$files_ $file_"
    done
    show_command vim -p $files_
    vim -p $files_
}

vtc () {
    vtr -c
}

vtr () {
    python ~/jab/src/python/tracebacks.py -e "$@"
}

vtt () {
    python "$1" | python ~/jab/src/python/vim_traceback.py -i
}

vwa () {
    _edit_work aliases.sh
}

vwe () {
    _edit_work environ.sh
}

vwf () {
    _edit_work functons.sh
}

vvb () {
    vvf sh.vim
}

vvf () {
    vvv ftplugin/$1
}

vvp () {
    vvf python
}

vvy () {
    vvf python/jab.vim
}


vvu () {
    __doc__="Edit ~/jab/vim files and ~/vim files if different"
    local _vimrc="$HOME/jab/vim/vimrc"
    local _vim="$HOME/jab/vim"
    diff -q $HOME/.vimrc $_vimrc || _vimrc="$HOME/.vimrc $_vimrc"
    diff -qr $HOME/.vim $_vim >/dev/null || _vim="$HOME/.vim $_vim"
    vvv $_vimrc $_vim "$@"
}

vvv () {
    (cd ~/jab/vim
    vv -g . "$@"
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
    vd ~/two ~/one "$@"
}

vd23 () {
    vd ~/two ~/three "$@"
}

vd32 () {
    vd ~/three ~/two "$@"
}

vd31 () {
    vd ~/three ~/one "$@"
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
    if [[ $three_ ]]; then
        vim $diff_opts_ "$one_"  "$two_" "$three_"
    else
        vim $diff_opts_ "$one_"  "$two_"
    fi
}


# v () {
#     [[ $1 ]] && vim_some "$@" || vim_none 
# }
#

vim_none () {
    (echo "" > ~/tmp/fred
    open /Applications/MacVim.app ~/tmp/fred)
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
