#! /bin/bash

# echo Welcome to $JAB/bashrc

source_file ()
{
    local path_to_file=$1
    shift
    local optional=
    [[ $1 == "optional" || $path_to_file =~ /local/ ]] && optional=1

    if [[ -z $path_to_file ]]
    then
        echo No file specified
    elif [[ -f $path_to_file ]]
    then
        source $path_to_file
    elif [[ -z $optional ]]
    then
        echo \"$path_to_file\" is not a file
    fi
}

_show_changes ()
{
    JAB_BASH=$JAB/src/bash
    if [[ -d $JAB/.svn ]]
    then svn stat $JAB
    elif [[ -d $JAB/.git ]]
    then git status $JAB
    fi
    source $JAB_BASH/subversion/source
    source $JAB_BASH/git/source
}

_source_jab ()
{
    [[ -f $JAB/jab_environ ]] && source $JAB/jab_environ || echo "Cannot find $JAB/environ" >&2
    local LOCAL=$JAB/local
    GITHUB_SOURCES=
    [[ -d ~/src/git/hub ]] && GITHUB_SOURCES=~/src/git/hub
    export GITHUB_SOURCES
    [[ -e /usr/bin/svn ]] && SVN_CLIENT=/usr/bin/svn
    [[ -e /usr/local/bin/svn ]] && SVN_CLIENT=/usr/local/bin/svn
    [[ -x $HOME/bin/python ]] && PYTHON=$HOME/bin/python
    source_file $JAB/bin/add_to_a_path.sh
    source_file environ
    source_file $JAB/python-environ optional
    source_file $LOCAL/environ
    source_file $LOCAL/python-environ optional
    source_file $JAB/prompt green
    source_file $LOCAL/prompt
    if [[ -n $GITHUB_SOURCES ]]
    then source_file $GITHUB_SOURCES/what/what.sh
    else alias what_source=source_file
    fi
    what_source $JAB/aliases
    what_source $LOCAL/aliases optional
    source_file $JAB/functons
    source_file $LOCAL/functons
    source_file $GITHUB_SOURCES/kd/kd.sh
    source_file $GITHUB_SOURCES/viack/viack optional
    source_file $JAB/src/bash/git-completion.bash
    _show_changes
}

_clean_jab()
{
    /bin/rm -rf $JAB/tmp/*
}

_show_todo ()
{
    builtin cd $JAB_PYTHON
    if python2.7 -c"a=0" >/dev/null 2>&1
    then test -f todo.py && python2.7 todo.py
    else
        local version=$(python -V 2>&1)
        echo "Python version is old ($version)"
    fi
    builtin cd - >/dev/null 2>&1
}

_welcome_home ()
{
    _show_todo
    if pgrep -fl vim > /dev/null
    then
        echo
        echo --------------------
        echo vim sessions running
        echo --------------------
        pgrep -fl vim
    fi
    echo
    echo Welcome jab, to $HOSTNAME
    echo
}

jab_bashrc()
{
    JAB=${JAB:-$HOME/.jab}
    if [[ ! -d $JAB ]]
    then
        echo i am lost because $JAB is not a directory >&2
    else
        builtin cd $JAB
        _source_jab
        _clean_jab
        _welcome_home
    fi
    source_file ~/.oldpwd optional
}

[[ $- == *i* ]] && jab_bashrc
builtin cd
