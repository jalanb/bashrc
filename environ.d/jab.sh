#! /bin/bash

_try_known_jab_paths () {
    local github_jab_dir=~/src/git/hub/dotjab
    [[ -d "$github_jab_dir" ]] || github_jab_dir=
    local myhome_jab_dir=~/.jab
    [[ -d "$myhome_jab_dir" ]] || myhome_jab_dir=
    local jab_dir=${github_jab_dir:-$myhome_jab_dir}
    [[ -d "$jab_dir" ]] || jab_dir=

    export JAB=${JAB:-jab_dir}
    [[ -d "$JAB" ]] || JAB=not_dir_jab
}

_source_jab_environ () {
    _try_known_jab_paths
    home_id=~/.ssh/id_jab
    [[ -f "$home_id" ]] && export JAB_ID=$home_id
    export JAB_PUB_ID=$JAB_ID.pub
    export JAB_SSH=$(dirname $JAB_PUB_ID)
    export JAB_HOME=$HOME
    JABS=
    [[ -d /usr/local/svn/jabs ]] && JABS=file:///usr/local/svn/jabs
    export JABS
}

_source_jab_environ
