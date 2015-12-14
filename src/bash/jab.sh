#! /bin/cat

[[ -z $HUB ]] && (echo "HUB is undefined"; ls -ld ~/src/git/hub) >&2

# x


# j () { cj; "$@"; }

# xx

# xx

# "c.*" means "cd ..."
cj () { cd $JAB/$1; }

# "r.* mean "require ...", but means "rm" elsewhere :-(

ri () { acquire_require; }
rh () { ri; [[ -z $1 ]] || require $HUB/$1; }
rj () { [[ -z $1 ]] && return; JAB=$HUB/jab; ri; [[ -z $1 ]] || require $JAB/$1; }

# xxx


cjb () { cd $JAB/src/bash/$1; }

# "rh." means "require ... in $HUB"

rh0 () { . ~/src/git/hub/what/what.sh; }
RHH () { . ~/src/git/hub/jab/src/bash/hub.sh; }
rha () { . $HUB/ack2vim/ack2vim.sh; . $HUB/ack2vim/grep_vim.sh; }
rhk () { . $HUB/kd/kd.sh; }
rhw () { . $HUB/what/what.sh; }


jjl () { (        set -e;         set -n;         date; cj; "$@") >> $JAB/log/jjj.log 2>&1;
         (set -a; set -e; set -h;         set -x; date; cj; "$@"; echo jjj; date;) >> $JAB/log/jjj.log 2>&1; }

# "rj." means "require ... in $JAB"

rja () { require_jab_sh aliases; }
rje () { require_jab_sh environ; }
rjf () { require_jab_sh functons; }
rjh () { require_jab_sh history; }
rjo () { require_jab_sh repo; }
rjr () { require_jab_sh rf; }
rjt () { require_jab_sh prompt; }
rjx () { require_jab_sh x; }
rjs () { rj src/$1; }
rjb () { rjs bash/$1 ; }
rjp () { rjs python/$1; }
rjg () { rjsb git/$1; }


# xxxx

rjbg () { rjsb git/$1; }
rjed () { rj environ.d/$1; }
rjgc () { require_jab_git_sh completion; }
rjgf () { require_jab_git_sh functons; }
rjgs () { require_jab_git_sh source; }
rjsb () { rjs bash/$1; }
rjsp () { rjs python/$1; }

# xxxxx

rjsbg () { rjbg $1; }
rjsps () { rjsp site/$1; }

rjedc () { require_jab_env colour; }
rjedo () { require_jab_env company; }
rjedp () { require_jab_env python; }

# xxxxxx
REQUIRE_ACQUIRED=
acquire_require () {
    [[ -n $REQUIRE_ACQUIRED ]] && return;
    REQUIRE_ACQUIRED=$(date)
    . $HUB/jab/src/bash/require.sh
}

# xxxxxxx
HUB_ACQUIRED=
require_scripts_under_hub () {
    [[ -n $HUB_ACQUIRED ]] && return;
	HUB_ACQUIRED=$(date)
	rh0; RHH; rha; rhk; rhw;
}

JAB_ACQUIRED=
require_scripts_under_jab () {
set -x
    require_scripts_under_hub
    [[ -n $JAB_ACQUIRED ]] && return;
	JAB_ACQUIRED=$(date)
    echo JAB, from HUB $JAB
    ri;
    rjedc; rjedo; rjedp;
    rja; rje; rjf; rjh; rjt; rjo; rjr; rjx;
    rjgc; rjgf; rjgs;
    cj;
set +x
}

require_jab_sh () {
    require_scripts_under_hub
    rjb $1
}

require_jab_git_sh () {
    require_scripts_under_hub
    rjg $1
}

require_jab_env () {
    require_scripts_under_hub
    rjed $1
}

require_jab_git_sh () {
    require_scripts_under_hub
    rjg $1
}

require_jab_git_sh () {
    require_scripts_under_hub
    rjg $1
}

require_jab_sh_all () {
    for f in $( (cj src/bash; ls *.sh;) ); do
        require_jab_sh $f
    done
}

