#! /bin/cat

_trap_jab () {
    [[ ! -d $JAB && -d $HUB/jab ]] && JAB=$HUB/jab
    _assert_directory $JAB
}

_trap_jab

_source_jab_environ () {
    source_what $JAB/environ.d/jab.sh
    source_what $JAB/environ.d/*
    source_what $JAB/local/*
}

source_jab () {
    _source_jab_environ
    for script in aliases.sh functons.sh prompt.sh src/bash/git/completion.sh; do
        source_what "$JAB/src/bash/$script" || continue
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

