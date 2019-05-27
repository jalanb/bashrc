#! /bin/cat

Welcome_to $BASH_SOURCE

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
        show_error "Nothing specified for add "
        show_error 'Did you mean "gaa" (add all) ?'
        return 1
    else
        show_run_command git add "$@" 
    fi
}

gb () {
    local _sought="$*"
    [[ $_sought ]] || _sought=.
    show_command "git branch $GIT_BRANCH_OPTION | grep $_sought" 
    git branch $GIT_BRANCH_OPTION 2>&1 | grep -v -e warning | grep --color $_sought
}

gd () {
    show_run_command git diff "$@" 
}

gf () {
    show_run_command git fetch --all
}

gi () {
    local __doc__="git in"
    local _storage=/tmp/gi.sh
    if [[ -z "$@" ]]; then git commit --verbose
    else
        python -c "print('git commit -m\"$*\"')" > $_storage
        cat $_storage
        bash $_storage
        rr $_storage
    fi
    GIT_ADDED=
}

gl () {
    git log "$@"
}

gm () {
    show_run_command git merge --no-ff --no-edit "$@" 
}

go () {
    local __doc__="git checkout"
    local _stashed=
    local _current_branch=$(current_branch)
    [[ "$@" == $_current_branch ]] && show_error "Already on $(current_branch)"
    [[ "$@" == $_current_branch ]] && return 0
    show_command "git checkout $@" 
    if git checkout -q "$@" 2>&1 | grep -q fred; then
        if _has_git_changes; then
            stash_herman || return 1
            _stashed=1
        fi
        show_command "git checkout $@" 
        git checkout -q "$@"
        # http://lmgtfy.com/?q=%22How+To+Hunt+Elephants%22+-%22Kettering%22
        [[ -n $_stashed ]] && echo "Cairo: git stash pop"
    fi
    return 0
}

gp () {
    show_command "git push $@" 
    if ! MSG=$(git push "$@" 2>&1); then
        if [[ $MSG =~ set-upstream ]]; then
            local _command=$(echo "$MSG" | grep set-upstream)
            show_run_command $_command 
        else
            show_error "$MSG" 
            return 1
        fi
    fi
}

gr () {
    show_run_command git pull --rebase "$@" 
}

gs () {
    local __doc__="""git status front end"""
    _gs "$@"
}

gt () {
    local _tag=
    for _tag in "$@"; do
        show_run_command git tag $_tag 
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

ts () {
    tig status
}

# _xx

_gs () {
    local __doc__="""git status back end"""
    show_run_command git status "$@" 
}

# xxx

egi () {
    GIT_EDITOR=true gi "$@"
}

gaa () {
    ga .
}

gac () {
    ga "$@"
    gcpc
}

gai () {
    local __doc__="""Add args interactively"""
    show_run_command git add --patch "$@"
}

gba () {
    GIT_BRANCH_OPTION=-a gb "$@"
}

gbb () {
    git_branch "$@"
}

gbr () {
    GIT_BRANCH_OPTION=-r gb "$@"
}

gbt () {
    gb "$@"
    gt "$@"
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
    show_run_command git branch -m "$@"
}

gbv () {
    show_run_command git blame "$1" | vin
}

gcp () {
    show_run_command git cherry-pick -x --allow-empty "$@"
}

gdd () {
    gdi .
}

gdi () {
    local __doc__="""git di args"""
    git di "$@"
}

gdh () {
    git dh "$@"
}

gdl () {
    git diff --color=always "$@"| fewer
}

gds () {
    local diff_=${1:-diff}
    git $diff_ --staged "$@"
}

gdv () {
    git dv "$@"
}

gff () {
    gf
    show_run_command git fetch --tags
}

gfp () {
    gff
    grup
}

ggi () {
    local __doc__=""""""
    gxi _gdis _ggi_response "$@"
}

gia () {
    show_command git commit --amend "$@"
    GIT_EDITOR=true git commit --amend "$@"
}

gie () {
    show_run_command git commit --amend --edit "$@"
}

gip () {
    gi "$@"
    gp
}

gl1 () {
    gl -n1 "$@"
}

glone () {
    local __doc__="""pronounced 'g l one'"""
    gl --oneline "$@"
}

gla () {
    git_on_screen lg --author=Alan.Brogan "$@"
}

glf () {
    GIT_LOG_ALIAS=lf GIT_LOG_LINES=$(( LINES / 2 )) git_on_lines "$@"
}

glg () {
    GIT_LOG_ALIAS=lg GIT_LOG_LINES=$_number_of_commits git_on_lines "$@"
    echo
}

gll () {
    git ll "$@"
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

glv () {
    git lg --color=never "$@" | vim -
}

gma () {
    show_run_command git merge --abort
}

gmm () {
    local _branch=$(current_branch)
    go master
    grr
    go $_branch
    gm master
}

gob () {
    go -b "$@"
}

gof () {
    gbD fred 2>/dev/null
    gob "$@" fred
}

gog () {
    go "$@"; glg; bump show
}

gom () {
    go master "$@"
}

gor () {
    go "$@"; gr
}

got () {
    if git branch -a | grep $1; then
        gor "$@"
    else
        show_run_command git "$@"
    fi
}

gpf () {
    gp --force-with-lease "$@"
}

gpo () {
    show_run_command git push origin "$@"
}

gpp () {
    gp "$@"
    gpt
}

gps () {
    git_stash_and gp "$@"
}

gpt () {
    gpo --tags
}

_gs_quiet () {
    first_arg_dir_or_here "$@" && shift
    _do_git_status $dir "$@"
}

_show_pre_loop () {
    show_green local
    show_this_branch
    show_green status
}

gra () {
    show_run_command git rebase --abort
}

grc () {
    show_command git rebase --continue
    GIT_EDITOR=true git rebase --continue | g "skip this commit" || return
    show_run_command git rebase --skip
}

grg () {
    gr; glg
}

grh () {
    show_run_command git reset HEAD "$@"
}

gri () {
    local __doc__="""Rebase args interactively"""
    local _args="HEAD~2"
    [[ "$@" ]] && _args="$@"
    show_run_command git rebase --interactive $_args
}

grm () {
    local _current_branch=$(current_branch)
    [[ $1 ]] && _current_branch=$1
    gor master
    show_run_command git rebase master $_current_branch
}

gro () {
    local _origin=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
    if [[ -n $_origin ]]; then
        echo $_origin
        return 0
    fi
    show_error No origin 
    return 1
}

grp () {
    grr "$@"
    read -p "Push? [Y]" reply
    [[ -z $reply || $reply == "y" || $reply == "Y" ]] && gpp "$@"
}

grr () {
    git_stash_and gr "$@"
}

grs () {
    show_run_command git rebase --skip
}

gsi () {
    local __doc__="""Menu to help clearing git status"""
    gxi _gsi_show_diff _gsi_response "$@"
}

gss () {
    local __doc__="""git short status"""
    gs --short "$@"
}

gst () {
    local __doc__="""git stash"""
    show_run_command git stash "$@"
}

gsp () {
    local __doc__="""Porcelain status"""
    gs --porcelain
}

gta () {
    gt "$@"
}

gtl () {
    gt "$@"
}

gtl () {
    gt --list "$@"
}

gvd () {
    local __doc__="""vim diff all changed files"""
    first_arg_dir_or_here "$@" && shift
    for f in $(gssd $dir | grep "^ M" | cut -dM -f2)
    do
        git dv $f
    done
    QUESTIONS=$(untracked $dir)
    [[ -n $QUESTIONS ]] && v $QUESTIONS
}

gvi () {
    local __doc__="""Menu to help vimming git status"""
    gxi _gvi_show_diff _gvi_response "$@"
}

gxi () {
    local __doc__=""""""
    local _show_diff=$1; shift
    local _response=$1; shift
    local _responded=
    _stashed=
    first_arg_dir_or_here "$@" && shift
    GXI_QUERY=
    show_green remote
    glg
    show_this_branch -r
    _show_pre_loop
    while git status --short "$dir"; do
        show_green staged
        git di --staged
        show_green files
        _responded=
        for _file in $(gssd_changes "$dir"); do
            [[ -n "$_file" ]] || continue
            _gxi_grep $_file $GXI_QUERY || continue
            $_show_diff "$_file"
            _gxi_request "$_file" || break
            $_response "$_file" && _responded=1
        done
        [[ $answer =~ [qQ] || -z $_responded ]] && break
        [[ $answer =~ [sS] ]] && _gxi_stash
        gi
        git status -v | g -q "working [a-z][a-z]* clean" && break
        [[ -n $QUESTIONS ]] && v $QUESTIONS
        _show_pre_loop
    done
    [[ -n $_stashed ]] && gstp
    git dn --staged
    git status
}

# xxxx

_gbd () {
    local _current_branch=$(current_branch)
    if [[ "$@" =~ $_current_branch ]]; then
        if [[ "$@" == "master" ]]; then
            show_error Please checkout another branch before deleting master 
            return 1
        else
            gom
        fi
    elif [[ "$@" =~ ^-[dD]$ ]]; then
        if [[ $_current_branch == "master" ]]; then
            show_error Please checkout another branch before deleting master 
            return 1
        fi
        read -p "OK to remove $_current_branch [y]? " -n1 answer
        if [[ -z $answer || $answer =~ [yY] ]]; then
            if git status 2>&1 | grep -q git.merge...abort; then
                gma
            fi
            gom 
            show_run_command git branch "$@" $_current_branch
        else
            return 1
        fi
        return 0
    fi
    show_run_command git branch "$@"
}

gbdr () {
    gbD
    gr
}

gbDD () {
    local _current_branch=$(current_branch)
    [[ "$@" ]] && _current_branch="$@"
    gbD "$@" && gpod $_current_branch
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

gcme () {
    gcm --edit "$@"
}

gdis () {
    gdi --staged "$@"
}

gipf () {
    gi "$@"
    gpf
}

godr () {
    gor development
    bump show
}

gomb () {
    gob "$@" master 
}

gomr () {
    gor master
    bump show
}

gorl () {
    gor "$@"
    glg
}

gcpa () {
    show_run_command git cherry-pick --abort
}

gcpe () {
    show_run_command git commit --allow-empty  -F .git/CHERRY_PICK_HEAD
}

gcpc () {
    GIT_EDITOR=true git cherry-pick --continue
}

gcpe () {
    show_run_command git cherry-pick --edit "$@"
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

gfff () {
    gff
    grup
}

gffm () {
    gff
    grup
    gomr
}

gl11 () {
    if [[ -n $1 ]]; then
        for sha1 in "$@"; do
            gl1 --oneline $sha1
        done
    else
        gl1 --oneline
    fi
}

glgs () {
    glg "$@"
    gs
}

glp1 () {
    glp -n1 "$@"
}

glf1 () {
    git lg -n1 "$@"
    git lg -n1 --compact-summary "$@" | kat -f 2 -l -2 | cut -d'|' -f2
}

gls1 () {
    GIT_LOG_LINES=31 gls -n1 "$@"
}

gpod () {
    gpo --delete "$@"
}

gpff () {
    gp --force "$@"
}

gppp () {
    gpf "$@"
    gpt
}

grmt () {
    local _current_branch=$(current_branch)
    show_run_command git rebase master $_current_branch -X theirs
}

grup () {
    show_run_command git remote update origin --prune
    show_run_command git gc
}

gsri () {
    git_stash_and gri "$@"
}

gssd () {
    local _dir="$1"; shift
    _status_line -C $_dir "$@"
}

gstb () {
    show_run_command git stash branch "$@"
}

gstl () {
    show_run_command git stash list
}

gstp () {
    show_run_command git stash pop
}

gtlg () {
    gtl | g "$@"
}

gvsd () {
    first_arg_dir_or_here "$@" && shift
    for _file in $(gssd $dir); do
        _gvi_vim "$_file"
    done
}

# xxxxx

gffff () {
    gfff
    gr
}

clone () {
    local _range=yes
    [[ "$1" == "-n" ]] && _range= && shift
    [[ "$1" == "-y" ]] && _range=ranger
    local _remote=
    [[ -n $1 ]] && _remote=$1 && shift
    local _local=
    [[ -n $1 ]] && _local=$1 && shift

    local _clone_log=/tmp/_clone.log
    echo "" > $_clone_log
    show_run_command git clone $_remote $_local > $_clone_log 2>&1
    if grep -q fatal $_clone_log; then
        kat -n $_clone_log
    else
        cd $(grep Cloning.into $_clone_log | sed -e "s/Cloning into '//" -e "s/'.*//")
        [[ -n $_range ]] && ranger
    fi
}

gorll () {
    gor "$@"
    git lg
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
    cde "$@" > ~/bash/fd/1 2> ~/bash/fd/2
}

verbosity () {
  # set -x
    [[ $2 =~ off ]] && STDOUT=off
    [[ $2 =~ on ]] && STDOUT=on
    for word in "$@"; do
        [[ $word =~ -[qQvV] ]] || continue
        [[ $word =~ .q ]] && STDOUT=off
        [[ $word =~ .Q ]] && STDERR=off
        [[ $word =~ .v ]] && STDOUT=on
        [[ $word =~ .V ]] && STDERR=on
    done
    echo $STDOUT
  # set +x
    true
}

git_root () {
    STDOUT=$(verbosity $1)
    _there=
    for word in $*; do
        [[ $word =~ -[qQvV] ]] && continue
        if [[ -e "$word" ]]; then
            _there="$word"
            shift
            break
        fi
    done
    [[ -f "$_there" ]] && _there=$(dirname_ $_there)
    [[ -d "$_there" ]] || echo "Not a dir '$_there'"
    [[ -d "$_there" ]] || return 1
    git -C "$_there" rev-parse --git-dir >/dev/null 2>&1 || return 1
    local _project_dir=$(git -C "$_there" rev-parse --show-toplevel | head -n 1)
    [[ -z $_project_dir ]] && _project_dir=.
    [[ -d $_project_dir ]] || echo "Not a dir: '$_project_dir'"
    local _root_dir=$(readlink -f $_project_dir)
    [[ -d $_root_dir ]] || echo "Not a dir: '$_root_dir'"
    [[ -d $_root_dir ]] || return 1
    [[ $STDOUT == off ]] || echo $_root_dir
    return 0
}

# xxxxxxxxxx

git_stash_and () {
    local stashed=
    if git_changed; then
        stashed=1
        show_command git stash
        git stash -q
    fi
    "$@"
    if [[ $stashed == 1 ]]; then
        gstp -q
    fi
}

_gxi_menu () {
    GSI_MENU=
    suffix=", "
    red_one "/"
    red_one q uit
    red_one a dd
    _git_modified $1 && red_two in t eractive
    red_two a m end
    red_two am e dit
    red_two sta g ed
    red_one s tash
    _git_modified $1 && red_one d iff
    red_two d r op
    red_two de l ete
    [[ -n $GIT_ADDED ]] && red_one f asten
    red_two comm i t
    red_one v im
    _git_modified $1 && red_one p atch
    suffix=";"
    red_one space " next"
    echo -n -e "$(_status_chars $1) $1: $GSI_MENU"
}

git_branch () {
    show_run_command git rev-parse --abbrev-ref HEAD
}

# xxxxxxxxxxx

clean_clone() {
    show_run_command git reset head .
    show_run_command git checkout .
    show_run_command git clean -f -d -f
    show_run_command git checkout master
    for branch in $(git branch | grep -v -e master -e deployed-to); do
        [[ -f $branch ]] && continue
        show_run_command git branch -d $branch
    done
}

git_changed () {
    local git_dir=$(git_root ${1:-$PWD})
    [[ -n $git_dir ]] || return 1
    git -C $git_dir status --porcelain | grep -q "$_git_status_regexp"
}

# xxxxxxxxxxxx

_gxi_request () {
    _gxi_menu $1
    read -e -n1 -p " " answer
    [[ $answer =~ [qQ] ]] && return 1
    return 0
}

gssd_changes () {
    local _dir="$1"; shift
    gssd "$_dir" | grep "^\([MDU ][MAU]\|??\)" | sed -e "s/^...//"
}

# xxxxxxxxxxxxx

git_on_lines () {
    local _number_of_commits=7
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        _number_of_commits=$1
        shift
    fi
    local _log_alias=lg
    [[ -n $GIT_LOG_ALIAS ]] && _log_alias=$GIT_LOG_ALIAS
    git status --short
    GIT_LOG_LINES=$(( LINES / 2 )) git_on_screen $_log_alias -n$_number_of_commits "$@" | _call_me_alan | sed -e "s/ ago//"
}

git_on_screen () {
    local cmd=$1; shift
    local _vertical_lines=${LINES:-$(screen_height)}
    local _one_third_of_vertical=$(( $_vertical_lines / 3 ))
    local _lines=${GIT_LOG_LINES:-$_one_third_of_vertical}
    git $cmd --color "$@" | head -n $_lines
}

untracked () {
    local _path="$1"; shift
    ( test -d "$_path" && gssd "$_path" || _status_line "$_path" ) | grep "??" | cut -d' ' -f2
}

_do_git_status () {
    local __doc__="get the status from git"
    [[ -d $1 ]] && dir=$1; shift
    [[ -z $dir || $(readlink -f $dir) == $(readlink -f .) ]] && dir=$PWD
    local _msg=
    [[ -d $dir ]] || _msg="Not a dir: $dir"
    STDOUT=off
    STDERR=on
    [[ -n "$@" && "$@" =~ -q ]] && STDOUT=off
    [[ -n "$@" && "$@" =~ -Q ]] && STDERR=off
    [[ -n "$@" && "$@" =~ -[vV] ]] && STDOUT=on
    if [[ -n $_msg ]]; then
        [[ $STDERR == "on" ]] && show_error $_msg 
    fi
    # set -x
    # set -e
    [[ -n $_msg ]] && return 1
    if git_root -q $dir; then
        show_error "Fail: git_root -q $dir" 
        return 1
    fi
    git -C $dir status "$@"
    # set +e
    # set +x
}

# xxxxxxxxxxxxxx

current_branch () {
    git rev-parse --abbrev-ref HEAD
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

# xxxxxxxxxxxxxxxx

# xxxxxxxxxxxxxxxxx

git_simple_status () {
    local arg_dir=${1:-$PWD}
    _has_git_changes $arg_dir || return
    local _git_dir=$(git_root $arg_dir)
    [[ -d $_git_dir ]] && gssd "$_git_dir" 2> ~/bash/fd/2 | grep "$_git_status_regexp"
}

_show_git_time_log () {
    if [[ -z $2 ]]; then
        git -C $git_dir lg > /dev/null | grep $1
    else
        git lg "$2" > /dev/null | grep $1
    fi
}

# xxxxxxxxxxxxxxxxxxxxxx

_call_me_alan () {
    sed \
        -e "s/.*al-got-rhythm.net/jalanb/" \
        -e "s/$(mail_work '.*')/Alan Brogan/" \
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

_gdis () {
    local __doc__="""git di args; git short status"""
    if _git_untracked "$1"; then
        kat -n "$1"
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
    git status --short $1
}

_gsi_show_diff () {
    if _git_untracked "$1"; then
        kat -n "$1"
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
    git status --short $1
}

_gvi_show_diff () {
    git diff "$1"
    git status --short $1
}

_ggi_response () {
    [[ $answer =~ [rR] ]] && _gsi_drop "$1" && return 0
    [[ $answer =~ [lL] && -f $1 ]] && rm -f "$1" && return 0
    [[ $answer =~ [vV] ]] && _gsi_vim "$1" && return 0
    _gxi_response "$@"
}

_gsi_response () {
    [[ $answer =~ [yY] ]] && ga "$1" && return 0
    _ggi_response "$@"
}

_gvi_response () {
    [[ $answer =~ [yY] ]] && ga "$1" && return 0
    _ggi_response "$@"
}

_gxi_response () {
    if [[ $answer =~ [iIgGdDpPtT] ]]; then
        [[ $answer =~ [iI] ]] && gi
        [[ $answer =~ [gG] ]] && git diff --staged
        if _git_modified "$1" ; then
            [[ $answer =~ [dD] ]] && git di "$1"
            [[ $answer =~ [pP] ]] && git diff --patch "$1"
            [[ $answer =~ [tT] ]] && gai "$1"
        fi
        _gxi_request "$1"
        return 0
    fi
    [[ $answer =~ [aA] ]] && ga "$1" && return 0
    [[ $answer =~ [mM] ]] && gcm "$1" && return 0
    [[ $answer =~ [eE] ]] && gcme "$1" && return 0
    if [[ $answer == "/" ]]; then
        read -p "/ " GXI_QUERY
        return 0
    fi
    return 1
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
    [[ -n "$*" ]] && git status --short . || git status --short "$@"
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

_gxi_grep () {
    local _file=$1; shift
    [[ -z "$@" ]] && return 0
    grep -q "$@" $_file
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
    _git_modified "$1" && git dv "$1" || git diff "$1" | vin
}


Bye_from $BASH_SOURCE
