#! /bin/bash -x


_source_jab_environ_d () {
}

_source_jab_environ () {
    _assert_source $JAB/environ
    _source_jab_environ_d
}

_source_jab () {
    _source_jab_environ
    JAB_ENVIRON_SOURCED=
    _assert_source "$JAB_LOCAL/network"
    for script in aliases functons prompt src/bash/git-completion.bash; do
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


bashrc_in_jab () {
    _trap_what
    _trap_jab
    _assert_is_function source_what
    source_what $JAB/src/bash/assertions
    _trap_python
    source_jab
    _show_welcome
}

_trap_file "$BASH_SOURCE"
[[ $- =~ i ]] && bashrc_in_jab
set +e
