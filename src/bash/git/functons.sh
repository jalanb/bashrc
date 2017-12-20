#! /bin/cat

. ~/jab/bin/first_dir.sh
. ~/jab/environ.d/colour.sh
. ~/jab/src/bash/keyboard/r.sh

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
        git branch $GIT_BRANCH_OPTION 2>&1 | grep -v warning
    else
        git branch $GIT_BRANCH_OPTION 2>&1 | grep -v warning | grep --color "$@";
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
    git log "$@"
}

go () {
    local __doc__="git out"
    if git checkout -q "$@" 2>&1 | grep -q fred; then
        stash_herman || return 1
        git checkout -q "$@"
        # http://lmgtfy.com/?q=%22How+To+Hunt+Elephants%22+-%22Kettering%22
        echo "Cairo: git stash pop"
    fi
    return 0
}

gp () {
    if ! MSG=$(git push "$@" 2>&1); then
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
    first_arg_dir_or_here "$@" && shift
    _do_git_status $dir "$@"
}

gt () {
    local _tag=
    for _tag in "$@"; do
        git tag "$_tag"
    done
}

tc () {
    local _global_config=; test -f ~/.gitconfig && _global_config=~/.gitconfig
    local _global_ignore=; test -f ~/.gitignore_global && _global_ignore=~/.gitignore_global
    local _local_config=; test -f .git/config && _local_config=.git/config
    local _local_ignore=; test -f .gitignore && _local_ignore=.gitignore
    local _local_creds=; test -f ~/.git-credentials && _local_creds=~/.git-credentials
    vim -p $_global_config $_global_ignore $_local_ignore $_local_config $_local_creds
}

# xxx

aga () {
    git reset HEAD "$@"
}

gaa () {
    ga .
}

gai () {
    ga --patch "$@"
}

gba () {
    GIT_BRANCH_OPTION=-a gb "$@"
}

gbt () {
    gb "$@"
    gt "$@"
}

gst () {
    git stash "$@"
}

gsp () {
    gs --porcelain
}

gta () {
    [[ -z $1 ]] && return ValueError
    gtlg "$@"
}

gtl () {
    gt --list "$@"
}

gbb () {
    git_branch "$@"
}

gbd () {
    _gbd -d "$@"
}

gbD () {
    _gbd -D "$@"
}

gbo () {
    gba "$@" | grep origin
}

gbm () {
    git branch -m "$@"
}

gff () {
    gfa
    grup
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

gca () {
    git commit --amend
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
    git fetch --tags
}

ggi () {
    gxi _ggi_show_diff _ggi_response "$@"
}

gff () {
    gfa
    grup
}

gl1 () {
    gl -n1 "$@"
}

gla () {
    git_on_screen lg --author=Alan.Brogan "$@"
}

glg () {
    gs
    local _number_of_commits=7
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        _number_of_commits=$1
        shift
    fi
    GIT_LOG_LINES=$_number_of_commits git_on_screen lg -n$_number_of_commits "$@" | _call_me_alan | sed -e "s/ ago//"
}

gln () {
    git_on_screen lg --name-only "$@"
}

glp () {
    gl -p "$@"
}

gls () {
    git_on_screen log --stat "$@"
}

glt () {
    git_on_screen lt "$@"
}

gma () {
    git merge --abort
}

gmm () {
    git merge master
}

gob () {
    go -b "$@"
}

god () {
    go development
}

gog () {
    go "$@"; glg; bump show
}

gor () {
    go "$@"; gr
}

gom () {
    go master
}

gop () {
    go python3
}

grc () {
    git rebase --continue
}

grg () {
    gr; glg
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

grp () {
    echo "Pull"
    grr "$@"
    read -p "Push? [Y]" reply
    [[ -z $reply || $reply == "y" || $reply == "Y" ]] && gpp "$@"
}

gpf () {
    gp --force "$@"
}

gpo () {
    git push origin "$@"
}

gpp () {
    gpf "$@"
    gpt
}

gps () {
    git_stash_and gp "$@"
}

gpt () {
    gpo --tags
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
    first_arg_dir_or_here "$@" && shift
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

_gxi_stash () {
    if [[ -z $_stashed ]]; then
        _stashed=gxi
        git stash
    fi
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
    gxi _gsi_show_diff _gsi_response "$@"
}

gta () {
    [[ -z $1 ]] && return ValueError
    gt "$@"
}

gvi () {
    gxi _gvi_show_diff _gvi_response "$@"
}

gxi () {
    local _gxi_show_diff=$1; shift
    local _gxi_response=$1; shift
    _stashed=
    first_arg_dir_or_here "$@" && shift
    while git status -s "$dir"; do
        for f in $(gssd_changes "$dir"); do
            [[ -n "$f" ]] || continue
            $_gxi_show_diff "$f"
            _gxi_request "$f"
            $_gxi_response "$f"
        done
        [[ $answer =~ [qQ] ]] && break
        [[ $answer =~ [sS] ]] && _gxi_stash
        gi
        git status -v | g -q "working [a-z][a-z]* clean" && break
        [[ -n $QUESTIONS ]] && v $QUESTIONS
    done
    [[ -n $_stashed ]] && git stash pop
}

_ggi_show_diff () {
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

_ggi_response () {
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

_gsi_show_diff () {
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

_gsi_response () {
    if [[ $answer =~ [fF] ]]; then gi; _gxi_request "$1"; fi
    [[ $answer =~ [aAyY] ]] && ga "$1"
    [[ $answer =~ [cC] ]] && gi
    [[ $answer =~ [rR] ]] && _gsi_drop "$1"
    if _git_modified "$1" ; then
        [[ $answer =~ [dD] ]] && git di "$1"
        [[ $answer =~ [iI] ]] && gai "$1"
    fi
    [[ $answer =~ [vV] ]] && _gsi_vim "$1"
}

_gvi_show_diff () {
    git diff "$1"
    git status -s $f
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

_gbd () {
    local _current_branch=$(git_branch)
    if [[ "$@" =~ $_current_branch ]]; then
        if [[ "$@" =~ "master" ]]; then
            echo Please checkout another branch before deleting master >&2
            return 1
        else
            gom
        fi
    elif [[ "$@" =~ ^-[dD]$ ]]; then
        if [[ $_current_branch == "master" ]]; then
            echo Please checkout another branch before deleting master >&2
            return 1
        fi
        read -p "OK to remove $_current_branch [y]? " -n1 answer
        if [[ -z $answer || $answer =~ [yY] ]]; then
            if git status 2>&1 | grep -q git.merge...abort; then
                git merge --abort
            fi
            git checkout -q master
            git branch "$@" $_current_branch
        fi
        return 0
    fi
    git branch "$@"
}

gaai () {
    local addable=.
    if [[ -e "$1" ]]; then
        addable=$1
        shift
    fi
    ga $addable && gi "$@"
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

gcpe () {
    git commit --allow-empty  -F .git/CHERRY_PICK_HEAD
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
    if [[ -n $1 ]]; then
        for commit in "$@"; do
            gl1 --oneline $commit
        done
    else
        gl1 --oneline
    fi
}

glgs () {
    local _number_of_commits=7
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        _number_of_commits=$1
        shift
    fi
    for branch in "$@"; do
        glg $_number_of_commits $branch
    done
}

glp1 () {
    glp -n1 "$@"
}

gls1 () {
    GIT_LOG_LINES=31 gls -n1 "$@"
}

gmmm () {
    local _branch=$(git_branch)
    go master
    grr
    go $_branch
    gmm
}

gpod () {
    gpo --delete $1
}

grmm () {
    grr
    gmmm
}

grup () {
    git remote update origin --prune
}

gstl () {
    gst --list
}

gstp () {
    gst pop
}

gsri () {
    git_stash_and gri "$@"
}

gssd () {
    local _dir="$1"; shift
    _status_line -C $_dir "$@"
}

gtlg () {
    gtl | g "$@"
}

gvsd () {
    first_arg_dir_or_here "$@" && shift
    for f in $(gssd $dir); do
        _gvi_vim "$f"
    done
}

# xxxxx

clone () {
    local _range=yes
    [[ "$1" == "-n" ]] && _range= && shift
    [[ "$1" == "-y" ]] && _range=ranger
    local _remote=
    [[ -n "$1" ]] && _remote="$1" && shift

    local _clone_log=/tmp/_clone.log
    echo "" > $_clone_log
    git clone "$_remote" > $_clone_log 2>&1
    if grep -q fatal $_clone_log; then
        kat -n $_clone_log
    else
        cd $(grep Cloning.into $_clone_log | sed -e "s/Cloning into '//" -e "s/'.*//")
        [[ -n $_range ]] && ranger
    fi
}

glone () {
    local __doc__="""pronounced 'g l one', because 'gl1' was taken"""
    gl --oneline "$@"
}

# xxxxxx
# xxxxxxx

_show_git_here () {
    git_root -q . || return
    local days=${1:-5}
    local _log=$(git -C $PWD log -n 1)
    [[ $? ]] && git -C $PWD lg --since="$days days ago"
}

# xxxxxxxx

_git_kd () {
    kd "$@" >/dev/null 2>&1
}

git_root () {
    local _quiet=
    if [[ $1 == '-q' ]]; then _quiet=True; shift; fi
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
    red_one s tash
    _git_modified $1 && red_one d iff
    red_two d r op
    [[ -n $GIT_ADDED ]] && red_one f asten
    red_one c ommit
    red_one v im
    _git_modified $1 && red_one i nteractive
    _git_modified $1 && red_one p atch
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
    local _dir="$1"; shift
    gssd "$_dir" | grep "^\([MDU ][MAU]\|??\)" | sed -e "s/^...//"
}

_run_storage () {
    bash $_storage
    rr $_storage
}

# xxxxxxxxxxxxx

git_on_screen () {
    local cmd=$1; shift
    local _vertical_lines=${LINES:-$(screen_height)}
    local _one_third_of_vertical=$(( $_vertical_lines / 4 ))
    local _lines=${GIT_LOG_LINES:-$_one_third_of_vertical}
    git $cmd --color "$@" | head -n $_lines
}

untracked () {
    local _path="$1"; shift
    ( test -d "$_path" && gssd "$_path" || _status_line "$_path" ) | grep "??" | cut -d' ' -f2
}

_do_git_status () {
    local __doc__="get the status from git"
    dir=$1; shift
    [[ -z $dir ]] && dir=$PWD
    git_root -q $dir || return 1
    git -C $dir status "$@"
}

# xxxxxxxxxxxxxx

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
    local _git_dir=$(git_root $arg_dir)
    [[ -d $_git_dir ]] && gssd "$_git_dir" 2>/dev/null | grep "$_git_status_regexp"
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
        -e "s/.*@wwts.com/Alan Brogan/" \
        -e "s/J Alan Brogan/Alan/"
}

grep_git_log_for_python_test_file ()
{
    local _number=$1; shift;
    gl --stat -n $_number | grep test_[a-z_]*.py | sed -e "s/\.py .*/.py/"
}

log_test_file ()
{
    grep_git_log_for_python_test_file 3
}
