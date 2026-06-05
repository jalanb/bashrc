#! /bin/cat

WORK_SOURCE="$(readlink -f "$BASH_SOURCE")"

# s is for smbc (.w is used by whyp)
.s () {
     source "$WORK_SOURCE"
}

. ~/jab/work/aliases.sh
