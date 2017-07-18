#! /bin/cat

. ~/jab/bin/first_dir.sh
. ~/jab/environ.d/colour.sh

# functons.sh for git

_git_status_char_regexp="[ MADRCU]"
_git_status_regexp="^${_git_status_char_regexp}${_git_status_char_regexp}"
# sorted by strcmp of function name

# x

# xx

ga () {
    [[ -n $GIT_ADDED ]] && GIT_ADDED="$@" || GIT_ADDED="$GIT_ADDED:""$@"
    if [[ -z "$*" ]]; then
        echo Nothing specified for add >&2
        echo 'Did you mean "gaa" (add all) ?'
        return 1
    else
        git add "$@"
    fi
}

gb () {
    if [[ -z "$*" ]]; then
        git branch 2>&1 | grep -v warning
    else
        git branch 2>&1 | grep -v warning | grep --color "$@";
    fi
}

gd () {
    git diff "$@"
}

gi () {
    local __doc__="git in"
    local _storage=/tmp/gi.sh
    if [[ -z "$@" ]]; then git commit --verbose
    else
        python -c "print('git commit -m\"$*\"')" > $_storage
        _show_run_storage
    fi
    GIT_ADDED=
}

gl () {
    gl11 "$@"
}

go () {
    local __doc__="git out"
    git checkout "$@"
}

gp () {
    if ! MSG=$(git push 2>&1); then
        if [[ $MSG =~ set-upstream ]]; then
            $(echo "$MSG" | grep set-upstream)
        else
            echo "$MSG" >&2
            return 1
        fi
    fi
}

gr () {
    git pull --rebase "$@"
}

gs () {
    shift_dir "$@" && shift
    _do_git_status $dir "$@"
}

gt () {
    git tag --list | g "$@"
}

tc () {
    vim ~/.gitconfig +
}

# xxx

aga () {
    git reset HEAD "$@"
}

gob () {
    go -b "$@"
}

gog () {
    go "$@"; glg
}

gor () {
    go "$@"; gr
}

grg () {
    gr; glg
}

gaa () {
    ga .
}

gac () {
    local addable=.
    if [[ -e "$1" ]]; then
        addable=$1
        shift
    fi
    ga $addable && gi "$@"
}

gai () {
    ga --patch "$@"
}

gba () {
    if [[ -z "$*" ]]; then
        git branch -a 2>&1 | grep -v warning
    else
        git branch -a 2>&1 | grep -v warning | grep --color "$@";
    fi
}

gbt () {
    gb "$@"
    gt "$@"
}

gbb () {
    git_branch "$@"
}

gbd () {
    git branch -d "$@"
}

gbD () {
    git branch -D "$@"
}

gbo () {
    gba "$@" | grep origin
}

gbm () {
    git branch -m "$@"
}

gff () {
    gfa; grup
}

gro () {
    local _origin=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
    if [[ -n $_origin ]]; then
        echo $_origin
        return 0
    fi
    echo No origin >&2
    return 1
}

gbv () {
    git blame "$1" | vin
}

gij () {
    local _storage=/tmp/gij.sh
    local JIT="git -C ~/jab"
    if [[ -z "$@" ]]; then $JIT commit --all --verbose
    else
        python -c "print '$JIT commit -m\"$*\"'" > $_storage
        _run_storage
    fi
}

gcp () {
    git cherry-pick -x --allow-empty "$@"
}

gdd () {
    gdi .
}

gdi () {
    git di "$@"
}

gdh () {
    git dh "$@"
}

gdl () {
    git diff --color=always "$@"| fewer
}

gdv () {
    git dv "$@"
}

gfa () {
    git fetch --all
}

_gl () {
    local cmd=$1
    shift
    local _vertical_lines=${LINES:-$(screen_height)}
    local _one_third_of_vertical=$(( $_vertical_lines / 4 ))
    local _lines=${GIT_LOG_LINES:-$_one_third_of_vertical}
    git $cmd "$@" | head -n $_lines
}


gl1 () {
    git log -n1 "$@"
}

gla () {
    _gl lg --author=Alan.Brogan "$@"
}

glg () {
    local _number_of_commits=7
    #if [[ $1 =~ [[:digit:]] && $1 !~ [[:alpha:]] ]]; then
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        _number_of_commits=$1
        shift
    fi
    # Show one line per commit
    GIT_LOG_LINES=$_number_of_commits _gl lg -n$_number_of_commits "$@" | _call_me_alan | sed -e "s/ ago//"
}

gln () {
    _gl lg --name-only "$@"
}

glp () {
    git log -p "$@"
}

gls () {
    _gl log --stat "$@"
}

glt () {
    _gl lt "$@"
}

gmm () {
    git merge master
}

god () {
    go development
}

gom () {
    go master
}

grc () {
    git rebase --continue
}

grp () {
    echo "Pull"
    grr "$@"
    read -p "Push? [Y]" reply
    [[ -z $reply || $reply == "y" || $reply == "Y" ]] && gpp "$@"
}

gpp () {
    git_stash_and git push "$@"
}

grh () {
    git reset HEAD "$@"
}

grc () {
    git rebase --continue
}

gri () {
    if [[ -n $1 ]]; then
        git rebase --interactive "$@"
    else
        git rebase --interactive HEAD~2
    fi
}

grr () {
    git_stash_and git pull --rebase "$@"
}

gsd () {
    shift_dir "$@" && shift
    for f in $(gssd $dir | grep "^ M" | cut -dM -f2)
    do
        git dv $f
    done
    QUESTIONS=$(untracked $dir)
    [[ -n $QUESTIONS ]] && v $QUESTIONS
}

gds () {
    local diff_=${1:-diff}
    git $diff_ --staged "$@"
}

red_one () {
    local red="\033[0;31m"
    local no_colour="\033[0m"
    GSI_MENU="${GSI_MENU}${red}${1}${no_colour}${2}${suffix}"
}

red_two () {
    local red="\033[0;31m"
    local no_colour="\033[0m"
    GSI_MENU="${GSI_MENU}${no_colour}${1}${red}${2}${no_colour}${3}${suffix}"
}

_status_line () {
    [[ -n "$*" ]] && git status -s . || git status -s "$@"
}

_status_chars () {
    git -C $dir status -s -- $1 | sed -e "s/\(..\).*/\1/"
}

_git_modified () {
    [[ $(_status_chars $1) == " M" ]]
}

_git_added () {
    [[ $(_status_chars $1) == " A" ]]
}

_git_untracked () {
    [[ $(_status_chars $1) == "??" ]]
}

_gsi_drop () {
    if [[ $answer =~ [rR] ]]; then
        _git_modified "$1" && go "$1"
        _git_untracked "$1" && rm -i "$1"
    fi
}

_gvi_drop () {
    if [[ $answer =~ [rR] ]]; then
        _git_modified "$1" && go "$1"
        _git_untracked "$1" && rm -f "$1"
    fi
}

_gvi_git_dv () {
    local _one="$1"
    shift
    _gvi_other_vim 
    if _git_modified "$1"; then
        git dv $(echo "$1" | cut -dM -f2)
    else
        _gvi_vim "$1"
    fi
}

_gvi_vim () {
    if _git_untracked "$1"; then
        v $(_status_line "$1" | grep "??" | cut -d' ' -f2)
    elif _git_modified "$1"; then
        v $(echo "$1" | cut -dM -f2)
    elif _git_added "$1"; then
        v  $(echo "$1" | cut -dA -f2)
    fi
    _status_line "$1"
}

_gsi_vim () {
    _git_modified $f && git dv $f || git diff $f | vin
}

gsi () {
    gxi _gsi_show_file _gsi_response "$@"
}

gta () {
    gt "$@"
}

gvi () {
    gxi _gvi_show_file _gvi_response "$@"
}

gxi () {
    local _gxi_show_file=$1; shift
    local _gxi_response=$1; shift
    shift_dir "$@" || shift
    while git status -s "$dir"; do
        for f in $(gssd_changes "$dir"); do
            [[ -n "$f" ]] || continue
            $_gxi_show_file "$f"
            _gxi_request "$f"
            $_gxi_response "$f"
        done
        [[ $answer =~ [qQ] ]] && break
        gi
        git status -v | g -q "working [a-z][a-z]* clean" && break
        [[ -n $QUESTIONS ]] && v $QUESTIONS
    done
}

gvsd () {
    shift_dir "$@" || shift
    for f in $(gssd $dir); do
        _gvi_vim "$f"
    done
}

_gsi_response () {
    if [[ $answer =~ [fF] ]]; then gi; _gxi_request "$1"; fi
    [[ $answer =~ [aA] ]] && ga "$1"
    [[ $answer =~ [cC] ]] && gi
    [[ $answer =~ [rR] ]] && _gsi_drop "$1"
    if _git_modified "$1" ; then
        [[ $answer =~ [dD] ]] && git di "$1"
        [[ $answer =~ [iI] ]] && gai "$1"
    fi
    [[ $answer =~ [vV] ]] && _gsi_vim "$1"
}

_gvi_response () {
    if [[ $answer =~ [fF] ]]; then 
        gi
        _gxi_request "$1"
    else
        [[ $answer =~ [aA] ]] && ga "$1"
        [[ $answer =~ [cC] ]] && gi
        [[ $answer =~ [rR] ]] && _gvi_drop "$1"
        if _git_modified "$1" ; then
            [[ $answer =~ [dD] ]] && git diff "$1" | vin
            [[ $answer =~ [iI] ]] && gai "$1"
            [[ $answer =~ [pP] ]] && gap "$1"
        fi
        [[ $answer =~ [vV] ]] && _gvi_vim "$1"
        [[ $answer =~ [wW] ]] && _gvi_git_dv "$1"
    fi
}

# xxxx

gbdr () {
    git push origin --delete $1
}

gbta () {
    gba "$@"
    gta "$@"
}

gcac () {
    ga .
    gcpc
}

godr () {
    gor development
    bump show
}

gomr () {
    gor master
    bump show
}

gcpa () {
    git cherry-pick --abort
}

gcpc () {
    git cherry-pick --continue
}

gcpe () {
    git cherry-pick --edit "$@"
}

gdsi () {
    gds di "$@"
}

gdsv () {
    gds dv "$@"
}

ggai () {
    g -q $1 $2 && gai $2 || echo fuck off
}

gfmr () {
    gffr gom
}

gfdr () {
    gffr god
}

gffr () {
    gff; $1; gr
}

gl11 () {
    gl1 --oneline "$@"
}

glp1 () {
    glp -n1 "$@"
}

gls1 () {
    gls -n1 "$@"
}

gmmm () {
    local _branch=$(git_branch)
    go master
    grr
    go $_branch
    gmm
}

gris () {
    git_stash_and gri "$@"
}

grmm () {
    grr
    gmmm
}

grup () {
    git remote update origin --prune
}

gssd () {
    local _dir="$1"; shift
    _status_line -C $_dir "$@"
}

# xxxxx

clone () {
    local _clone_log=/tmp/_clone.log
    echo "" > $_clone_log
    git clone "$1"> $_clone_log 2>&1
    if grep -q fatal $_clone_log; then
        kat -n $_clone_log
    else
        cd $(grep Cloning.into $_clone_log | sed -e "s/Cloning into '//" -e "s/'.*//")
        ranger .
    fi
}

# xxxxxx
# xxxxxxx

_show_git_here () {
    [[ -d "$PWD/.git" ]] || return
    local days=${1:-5}
    local _log=$(git -C $PWD log -n 1)
    [[ $? ]] && git -C $PWD lg --since="$days days ago"
}

# xxxxxxxx

_git_kd () {
    kd "$@" >/dev/null 2>&1
}

git_root () {
    _there="$1"; shift
    [[ -f "$_there" ]] && _there=$(dirname $_there)
    [[ -d "$_there" ]] || return 1
    (_git_kd "$_there"; git rev-parse --git-dir) >/dev/null 2>&1 || return 1
    local _root=$(_git_kd "$_there"; git rev-parse --git-dir 2>/dev/null)
    _root=${_root%%.git}
    if [[ -z $_root ]]; then
        echo $(realpath $_there);
    else
        echo $(realpath $_root);
    fi
}

# xxxxxxxxxx

git_stash_and () {
    local stashed=
    if git_changed; then
        stashed=1
        git stash -q
    fi
    "$@"
    if [[ $stashed == 1 ]]; then
        git stash pop -q
    fi
}

_gxi_menu () {
    GSI_MENU=
    suffix=", "
    red_one q uit
    red_one a dd
    red_one c ommit
    _git_modified $1 && red_one d iff
    _git_modified $1 && red_one i nteractive
    _git_modified $1 && red_one p atch
    red_two d r op
    [[ -n $GIT_ADDED ]] && red_one f asten
    red_one v im
    suffix=";"
    red_one hjkl " move"
    echo -n -e "$(_status_chars $1) $1: $GSI_MENU"
}

git_branch () {
    git rev-parse --abbrev-ref HEAD
}

# xxxxxxxxxxx

git_changed () {
    local git_dir=$(git_root ${1:-$PWD})
    [[ -n $git_dir ]] || return 1
    git -C $git_dir status --porcelain | grep -q "$_git_status_regexp"
}

# xxxxxxxxxxxx

_gxi_request () {
    _gxi_menu $1
    read -e -n1 -p " " answer
    [[ $answer =~ [qQ] ]] && break
}

gssd_changes () {
    gssd "$1" | grep "^\([MDU ][MAU]\|??\)" | sed -e "s/^...//"
}

_run_storage () {
    bash $_storage
    rr $_storage
}

# xxxxxxxxxxxxx

untracked () {
    (-d "$1" && gssd "$1" || _status_line "$1") | grep "??" | cut -d' ' -f2
}

_do_git_status () {
    local __doc__="get the status from git"
    dir=$1; shift
    [[ -z $dir ]] && dir=$PWD
    # [[ -d "${dir}/.git" ]] || return
    git -C $dir status "$@"
}

# xxxxxxxxxxxxxx

_gsi_show_file () {
    if _git_untracked "$1"; then
        kat -n "$f"
        return 0
    fi
    if _git_modified "$1"; then
        local _lines=$(wc -l "$1" | cut -d ' ' -f1)
        if [[ $_lines < $LINES ]]; then
            git di "$1"
        else
            gdi "$1"
        fi
    fi
    git status -s $f
}

_gvi_show_file () {
    git diff "$1"
    git status -s $f
}

show_git_time () {
    local _arg_dir="${1:-$PWD}"
    git_dir=$(git_root "$_arg_dir")
    [[ $git_dir == $_arg_dir ]] && _arg_dir=
    if [[ -n $git_dir ]]; then
        echo
        return 1
    fi
    local _log=
    local period=
    local lines_left=$(( ${LINES:-$(screen_height)} / 2 ))
    for period in seconds minutes hours days weeks "month | grep -v year" year
    do
        regexp=$period.ago
        _log=$(_show_git_time_log $regexp $_arg_dir)
        if [[ -n $_log ]]; then
            period_lines=$(_show_git_time_log $regexp $_arg_dir | wc -l)
            _show_git_time_log $regexp $_arg_dir | _call_me_alan | sed -e "s/ ago//" | head -n $lines_left
            [[ $period_lines -gt $lines_left ]] && break
            lines_left=$(( lines_left - $period_lines ))
        fi
    done
    echo
}

# xxxxxxxxxxxxxxx

_any_git_changes () {
    local __doc__="whether the current dir has modified or untacked files"
    local dir=$1
    [[ -z $dir ]] && dir=$PWD
    if [[ -d "${dir}/.git" ]]; then
        git -C $dir status --porcelain | gre "$_git_status_regexp"
    fi
}

_has_git_changes () {
    local dir=$1
    local _files=$(_any_git_changes $dir)
    [[ -n $_files ]]
}

# xxxxxxxxxxxxxxxxx

git_simple_status () {
    local arg_dir=${1:-$PWD}
    _has_git_changes $arg_dir || return
    local git_dir=$(git_root $arg_dir)
    [[ -n $git_dir ]] && gssd "$git_dir" 2>/dev/null | grep "$_git_status_regexp"
}

_show_git_time_log () {
    if [[ -z $2 ]]; then
        git -C $git_dir lg 2> /dev/null | grep $1
    else
        git lg "$2" 2> /dev/null | grep $1
    fi
}

_show_run_storage () {
    cat $_storage
    _run_storage
}

# xxxxxxxxxxxxxxxxxxxxxx

_call_me_alan () {
    sed \
        -e "s/.*al-got-rhythm.net/jalanb/" \
        -e "s/.*wwts.com/Alan Brogan/" \
        -e "s/J Alan Brogan/Alan/"
}

grep_git_log_for_python_test_file ()
{
    local _number=$1; shift;
    git log --stat -n $_number | grep test_[a-z_]*.py | sed -e "s/\.py .*/.py/"
}

log_test_file ()
{
    grep_git_log_for_python_test_file 3
}
