#! /bin/cat

source ~/jab/src/bash/asserts.sh

_assert_directory ~/jab_SH

_source_jab_environ_d () {
    for _file in $(find ~/jab/environ.d -type f | tr '\n' ' '); do
        _assert_source $_file
    done
}
_assert_directory ~/jab_SH/git

_assert_directory ~/jab/src/dir

_source_jab_environ () {
    _assert_source ~/jab/environ.d/jab.sh
    _source_jab_environ_d
}

_source_jab_scripts () {
    require "~/jab/environ.d/jab.sh"
    require "~/jab/environ.d/python.sh"
    require "~/jab/local/network"
    require "~/jab/src/bash/aliases.sh"
    require "~/jab/src/bash/functons.sh"
    require "~/jab/src/bash/prompt.sh"
    requite "~/hub/kd/kd.sh"
    requite "~/hub/vimack/vimack"
}


_remove_jab_tmp_files () {
    /bin/rm -rf "~/jab"/tmp/*
}

_show_todo () {
    builtin cd "~/jab/src/python"
    if python -c"a=0" >/dev/null 2>&1; then
        [[ -f "todo.py" ]] && pyth todo.py
    else
        local version=$(pyth -V 2>&1)
        echo "Python version is old ($version)"
    fi
    builtin cd - >/dev/null 2>&1
}

_jab_status () {
    if [[ ! -d "~/jab"/.git ]]; then
        $(cd ~/jab; git init .)
    fi
    git -C "~/jab" status | \
    grep -v "nothing to commit, working directory clean" | \
    sed -e s:Your.branch:\~/jab: | \
    grep --color 'up-to-date.*'
    _assert_source ~/jab_SH_GIT/source
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

_assert_file ~/jab_SH/assertions.sh

bashrc_in_jab () {
    _trap_github
    _trap_jab
    builtin cd ~/jab
    _trap_what
    _assert_is_function source-whyp
    source-whyp ~/jab_SH/assertions
    _trap_python
    _show_welcome
}

_trap_file "$BASH_SOURCE"
[[ $- =~ i ]] && bashrc_in_jab
set +e
