#! /bin/cat

_trap_jab () {
    [[ ! -d ~/jab/jab && -d $HUB/jab ]] && JAB=$HUB/jab
    _assert_directory ~/jab/jab
}

_trap_jab

_source_jab_environ () {
    source_what ~/jab/jab/environ.d/jab.sh
    source_what ~/jab/jab/environ.d/*
    source_what ~/jab/jab/local/*
}

source_jab () {
    _source_jab_environ
    for script in aliases.sh functons.sh prompt.sh src/bash/git/completion.sh; do
        source_what "~/jab/jab/src/bash/$script" || continue
    done
}

_jab_status () {
    if [[ ! -d "~/jab/jab"/.git ]]; then
        $(cd ~/jab/jab; git init .)
    fi
    git -C "~/jab/jab" status | \
    grep -v "nothing to commit, working directory clean" | \
    sed -e s:Your.branch:\~/jab/jab: | \
    grep --color 'up-to-date.*'
    source_what ~/jab/jab/src/bash/git/source
}

_remove_jab_tmp_files () {
    /bin/rm -rf "~/jab/jab"/tmp/*
}

