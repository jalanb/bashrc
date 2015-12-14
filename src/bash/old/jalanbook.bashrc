#! /bin/cat

JAB_SH=$JAB/src/bash
source $JAB_SH/asserts.sh

_assert_directory $JAB_SH

_source_jab_environ_d () {
    for _file in $(find $JAB/environ.d -type f | tr '\n' ' '); do
        _assert_source $_file
    done
}
_assert_directory $JAB_SH/git

JAB_SH_GIT=$JAB_SH/git
_assert_directory $JAB_SH_GIT

_source_jab_environ () {
    _assert_source $JAB/environ.d/jab.sh
    _source_jab_environ_d
}

_source_jab_scripts () {
    require "$JAB/environ.d/jab.sh"
    require "$JAB/environ.d/python.sh"
    require "$JAB/local/network"
    require "$JAB/src/bash/aliases.sh"
    require "$JAB/src/bash/functons.sh"
    require "$JAB/src/bash/prompt.sh"
    requite "$HUB/kd/kd.sh"
    requite "$HUB/ack2vim/ack2vim"
}


_remove_jab_tmp_files () {
    /bin/rm -rf "$JAB"/tmp/*
}

_show_todo () {
    builtin cd "$JAB/src/python"
    if python2.7 -c"a=0" >/dev/null 2>&1; then
        [[ -f "todo.py" ]] && mython todo.py
    else
        local version=$(mython -V 2>&1)
        echo "Python version is old ($version)"
    fi
    builtin cd - >/dev/null 2>&1
}

_jab_status () {
    if [[ ! -d "$JAB"/.git ]]; then
        $(cd $JAB; git init .)
    fi
    git -C "$JAB" status | \
    grep -v "nothing to commit, working directory clean" | \
    sed -e s:Your.branch:\$JAB: | \
    grep --color 'up-to-date.*'
    _assert_source $JAB_SH_GIT/source
}

_show_welcome () {
    _show_todo
    if pgrep -fl vim > /dev/null; then
        echo
        echo --------------------
        echo vim sessions running
        echo --------------------
        pgrep -fl vim | grep -v -e YouCompleteMe -e bash.*vim.sh
    fi
    _jab_status
    echo
    echo "Welcome jab, to $HOSTNAME"
    echo
}

_assert_file $JAB_SH/assertions.sh

bashrc_in_jab () {
    _trap_github
    _trap_jab
    builtin cd $JAB
    _trap_what
    _assert_is_function source_what
    source_what $JAB_SH/assertions
    _trap_python
    _show_welcome
}

_trap_file "$BASH_SOURCE"
[[ $- =~ i ]] && bashrc_in_jab
set +e
