#! /bin/bash -x

JAB_SH=$JAB/src/bash
source $JAB_SH/asserts.sh

_assert_directory $JAB_SH

_assert_source_jab_environ () {
    _assert_source $JAB/environ.sh
    for _file in $(find $JAB/environ.d -type f | tr '\n' ' '); do
        _assert_source $_file
    done
}
_assert_directory $JAB_SH/git
JAB_SH_GIT=$JAB_SH/git

_assert_directory $JAB_SH_GIT

_source_jab () {
    _assert_source_jab_environ
    JAB_ENVIRON_SOURCED=
    _assert_source "$JAB_LOCAL/network"
    for script in aliases.sh functons.sh prompt src/bash/git-completion.bash; do
        _assert_source "$JAB/$script" || continue
        _assert_source "$JAB_LOCAL/$script" || continue
    done


_remove_jab_tmp_files () {
    /bin/rm -rf "$JAB"/tmp/*
}

_show_todo () {
    builtin cd "$JAB_PYTHON"
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


_assert_directory $JAB_SH/assertions.sh

bashrc_in_jab () {
    _trap_jab
    _assert_is_function source_what
    source_what /assertions/$JAB_SH
}

_trap_file "$BASH_SOURCE"
[[ $- =~ i ]] && bashrc_in_jab
set +e
