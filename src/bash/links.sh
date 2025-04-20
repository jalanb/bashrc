
link_path () {
    local path_=$1 name_=$2
    [[ $name_ ]] || name=$(basename $path_)
    if [[ -e $name_ ]]; then
        if [[ -L $name_ ]]; then 
            rm -f $name_
        else
            echo "~/$name_ exists and is not a link"
            ls -la $name_
            return 1
        fi
    fi
    ln -s $path_ $name_
}

link_dir () {
    local dir_=$1 name_=$2
    [[ -d $dir_ ]] || mkdir -p $dir_
    link_path $dir_ 
}

link_clone () {
    local name_=$1
    local url_=https://github.com/jalanb/$name_
    local clone_=/opt/clones/github/jalanb/${name_}s/__main__
    [[ -d $clone_/.git ]] || git clone -q $url_ $clone_
    link_path $clone_ $name_
}

cd $HOME

link_dir /opt/clones/github hub
link_dir /opt/clones/gitlab lab
link_dir /opt/clones/github/jalanb

link_clone pysyte
link_clone whyp
link_clone cde
link_clone zatso

link_path $(readlink -f ~/cde)/cde.sh
link_path $(readlink -f ~/whyp)/whyp.sh

# this file is CLONE/src/bash/links.sh
jab_clone=$(dirname $(dirname $(dirname $(readlink -f $BASH_SOURCE))))
link_path $jab_clone jab

link_path ~/jab/src/bash
link_path ~/jab/src/python
link_path ~/jab/environ.d env

link_path ~/jab/home/ackrc .ackrc
link_path ~/jab/home/dircolors .dircolors
link_path ~/jab/home/editrc .editrc
link_path ~/jab/home/gitconfig .gitconfig
link_path ~/jab/home/gitignore_global gitignore_global.
link_path ~/jab/home/inputrc .inputrc
link_path ~/jab/home/ipython .ipython
link_path ~/jab/home/pythonrc.py .pythonrc.py
link_path ~/jab/home/sackrc .sackrc
link_path ~/jab/home/tigrc .tigrc
link_path ~/jab/home/tmuxrc .tmux.conf
link_path ~/jab/home/vim .vim
link_path ~/jab/home/vimrc .vimrc

link_path ~/bash/keyboard keys
link_path ~/bash/prompt.sh
link_path ~/bash/bashrc_minimal .minimal
link_path ~/bash/bashrc .bashrc
link_path ~/bash/bash_profile .bash_profile

link_path ~/tmp/one
link_path ~/tmp/two
link_path ~/tmp/three

