#! /bin/bash

_trap_jab () {
    [[ ! -d $JAB && -d $GITHUB/dotjab ]] && JAB=$GITHUB/dotjab
    _assert_directory $JAB
}

_trap_jab

_source_jab_environ () {
    source_what $JAB/environ
    source_what $JAB/environ.d/*
    source_what $JAB/local/*
}

source_jab () {
    _source_jab_environ
    for script in aliases functons prompt src/bash/git-completion.bash; do
        source_what "$JAB/$script" || continue
    done
}

_jab_status () {
    if [[ ! -d "$JAB"/.git ]]; then
        $(cd $JAB; git init .)
    fi
    git -C "$JAB" status | \
    grep -v "nothing to commit, working directory clean" | \
    sed -e s:Your.branch:\$JAB: | \
    grep --color 'up-to-date.*'
    source_what $JAB/src/bash/git/source
}

_remove_jab_tmp_files () {
    /bin/rm -rf "$JAB"/tmp/*
}

