#! /bin/cat -n

Welcome_to $BASH_SOURCE

export REQUIRE_SH=$(realpath $BASH_SOURCE)

_require () {
    _source=source
    if [[ -z $WHYP_SOURCED ]]; then
        echo source whyp
        if [[ -d ~/hub ]]; then
            $_source ~/hub/whyp/whyp.sh
        else
            echo "~/hub is not a directory" >&2
            return 1
        fi
    fi
    if [[ -n $WHYP_SOURCED ]]; then
        _source=source_whyp
    fi
    $_source "$@"
}

_find_from () {
    find $1 -name $2
}

_re_find () {
    find $1 -name $2
}

_counter () {
    wc -l | sed -e "s/ *//"
}

_require_from () {
    local _repo=$1
    local _name=$(basename_ $2)
    local _count=$(_find_from $_repo $_name | _counter)
    local _found=
    local _src=_repo
    [[ $_count == 0 ]] && continue
    if [[ $_count != 1 ]]; then
        _src=~/jab/src
        _count=$(_find_from $_src $_name | _counter)
    fi
    if [[ $_count == 1 ]]; then
        _found=$(_re_find $_src $_name);
    else
        echo "$_count \"${_name}\"s required:" >&2
        for _found in $(_find_from $_src $_name); do
            echo "    $_found"
        done
    fi
    [[ -f $_found ]] && _require $_found
}

_ls_dot_sh () {
    local __doc__=""
    local _name=$1
    if [[ -f $1 ]]; then echo $1; return 0; fi
    local _script=${1}.sh
    if [[ -f $_script ]]; then ls $_script; return 0; fi
    (set -e; ls $_script)
}

_require_file_in () {
    cd $1;
    _require $(_ls_dot_sh $2)
}

require () {
    local _dir_path=.
    if [[ -d $1 ]]; then _dir_path=$1; shift; fi
    [[ ! -d $1 ]] && _require_file_in $_dir_path $1
}

requires () {
    echo "requires ($*)"
    local _dir_path=.
    if [[ -d $1 ]]; then
        _dir_path=$1
        shift
    fi
    echo "require $_dir_path, then require $*";
    for arg in $*; do
        require $dirname $arg;
    done;
}

require_sh () {
    _require $(_ls_dot_sh $1)
}

Welcome_to ~/bash/jab.sh.cut

qh () { ar; [[ -z $1 ]] || require ~/hub/$1; }

qj () { [[ -z $1 ]] && return; ar; [[ -z $1 ]] || require ~/jab/$1; }

qja () { require_jab_sh aliases; }
qje () { require_jab_sh environ; }
qjf () { require_jab_sh functons; }
qjh () { require_jab_sh history; }
qjo () { require_jab_sh repo; }
qjr () { require_jab_sh rf; }
qjt () { require_jab_sh prompt; }
qjx () { require_jab_sh x; }

qjgc () { require_jab_git_sh completion; }
qjgf () { require_jab_git_sh functons; }
qjgs () { require_jab_git_sh source; }

qjedc () { require_jab_env colour; }
qjedo () { require_jab_env company; }
qjedp () { require_jab_env python; }

REQUIRE_ACQUIRED=
acquire_require () {
    [[ -n $REQUIRE_ACQUIRED ]] && return;
    REQUIRE_ACQUIRED=$(date)
    . ~/hub/jab/src/bash/require.sh
}

HUB_ACQUIRED=
require_scripts_under_hub () {
    [[ -n $HUB_ACQUIRED ]] && return;
    HUB_ACQUIRED=$(date)
    qh0; qh1; qha; qhk; qhw;
}

HAVE_ACQUIRED=
require_scripts_under_jab () {
set -x
    require_scripts_under_hub
    [[ -n ~/jab_ACQUIRED ]] && return;
    HAVE_ACQUIRED=$(date)
    acquire_require;
    qjedc; qjedo; qjedp;
    qja; qje; qjf; qjh; qjt; qjo; qjr; qjx;
    qjgc; qjgf; qjgs;
    cj;
set +x
}

require_jab_sh () {
    require_scripts_under_hub
    qjb $1
}

require_jab_git_sh () {
    require_scripts_under_hub
    qjg $1
}

require_jab_env () {
    require_scripts_under_hub
    qjed $1
}

require_jab_git_sh () {
    require_scripts_under_hub
    qjg $1
}

require_jab_git_sh () {
    require_scripts_under_hub
    qjg $1
}

require_jab_sh_all () {
    for f in $( (cj src/bash; ls *.sh;) ); do
        require_jab_sh $f
    done
}

Bye_from $BASH_SOURCE
