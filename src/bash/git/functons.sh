#! /bin/cat

. ~/jab/bin/first_dir.sh
. ~/jab/environ.d/colour.sh

# functons.sh for git

_git_status_char_regexp="[ MADRCU]"
_git_status_regexp="^$_git_status_char_regexp$_git_status_char_regexp"
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

gc () {
    local _storage=/tmp/gc.sh
    if [[ -z "$@" ]]; then git commit --verbose
    else
        python -c "print 'git commit -m\"$*\"'" > $_storage
        _show_run_storage
    fi
    GIT_ADDED=
}

gd () {
    git diff "$@"
}

gi () {
    git "$@"
}

gp () {
    if ! git push 2>/dev/null; then
        $(git push 2>&1 | grep set-upstream)
    fi
}

gr () {
    git pull --rebase "$@"
}

gs () {
    shift_dir "$@" && shift
    _do_git_status $dir "$@"
}

tc () {
    vim ~/.gitconfig +
}

# xxx

aga () {
    git reset HEAD "$@"
}

gaa () {
    ga .
}

gbv () {
    git blame "$1" | vin
}

gac () {
    local addable=.
    if [[ -e "$1" ]]; then
        addable=$1
        shift
    fi
    ga $addable && gc "$@"
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

gcj () {
    local _storage=/tmp/gcj.sh
    local JIT="git -C ~/jab"
    if [[ -z "$@" ]]; then $JIT commit --all --verbose
    else
        python -c "print '$JIT commit -m\"$*\"'" > $_storage
        _run_storage
    fi
}

gcm () {
    git co master
}

gcp () {
    git cherry-pick "$@"
}

gdd () {
    gdi .
}

gdi () {
    git di "$@"
}

gdis () {
    git di --staged "$@"
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

gdvs () {
    git dv --staged "$@"
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
    # Show full log for quarter of screen
    git log -n$_number_of_commits --stat --color "$@" | head -n $(( LINES / 4 ))
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

grp () {
    echo "Pull"
    grr "$@"
    read -p "Push? [Y]" reply
    [[ -z $reply || $reply == "y" || $reply == "Y" ]] && gpp "$@"
}

gpp () {
    _git_stash_and push "$@"
}

grh () {
    git reset HEAD "$@"
}

gri () {
    if [[ -n $1 ]]; then
        git rebase --interactive "$@"
    else
        git rebase --interactive HEAD~2
    fi
}

grr () {
    _git_stash_and pull --rebase "$@"
}

gsd () {
    shift_dir "$@" && shift
    for f in $(git -C $dir status -s | grep "^ M" | cut -dM -f2)
    do
        git dv $f
    done
    STATUS_QUESTIONS=$(git -C $dir status -s | grep "??" | cut -d' ' -f2)
    [[ -n $STATUS_QUESTIONS ]] && v $STATUS_QUESTIONS
}

gris () {
    git stash
    gri "$@"
    git stash pop
}

_gsi_opt () {
    local red='\[\033[0;31m\]'
    red="\033[0;31m"
    local no_colour='\[\033[0m\]'
    no_colour="\033[0m"
    GSI_MENU="${GSI_MENU}${red}${1}${no_colour}${2}${suffix}"
}

_gsi_menu () {
    GSI_MENU=
    suffix=", "
    _gsi_opt q uit
    _gsi_opt a dd
    _gsi_opt c ommit
    _git_modified $1 && _gsi_opt i nteractive
    _git_modified $1 && _gsi_opt p atch
    _gsi_opt d rop
    [[ -n $GIT_ADDED ]] &&_gsi_opt f asten
    _gsi_opt v im
    suffix=";"
    _gsi_opt hjkl " move"
    echo -n -e "$(_status_chars $1) $1: $GSI_MENU"
}

_gsi_vim () {
    _git_modified $f && git dv $f || vim $f
}

_gsi_prompt () {
    _gsi_menu $1
    read -e -n1 -p " " answer
}

gdsi () {
    git di "$@"
}

_gsi_show_file () {
    local _filename=$1
    local _lines=$(wc -l "$_filename" | cut -d ' ' -f1)
    if [[ $_lines < $LINES ]]; then
        git di "$_filename"
    else
        gdi "$_filename"
    fi
}

gsi () {
    shift_dir "$@" || shift
    for f in $(git -C $dir status -s | grep "^\([MDU ][MU]\|??\)" | sed -e "s/^...//")
    do
        [[ -z "$f" ]] && continue
        _git_modified "$f" && _gsi_show_file "$f" || (_git_untracked "$f" && fewer "$f" || continue )
        _gsi_prompt "$f"
        if [[ $answer =~ [fF] ]]; then gc; _gsi_prompt "$f"; fi
        [[ $answer =~ [qQ] ]] && break
        [[ $answer =~ [aA] ]] && ga "$f"
        [[ $answer =~ [iI] ]] && (_git_modified "$f" && gai "$f" || (_git_untracked "$f" && echo Cannot split untracked file))
        [[ $answer =~ [pP] ]] && (_git_modified "$f" && gap "$f" || (_git_untracked "$f" && echo Cannot split untracked file))
        [[ $answer =~ [dD] ]] && (_git_modified "$f" && git co "$f" || (_git_untracked "$f" && rm -i "$f"))
        [[ $answer =~ [vV] ]] && _gsi_vim "$f"
        [[ $answer =~ [cC] ]] && git commit
    done
    gc
    [[ -n $STATUS_QUESTIONS ]] && vimcat $STATUS_QUESTIONS
}

gsv () {
    shift_dir "$@" || shift
    for f in $(git -C $dir status -s)
    do
        if echo $f | grep -q "^ M" ;then
            git dv $(echo $f | cut -dM -f2)
        elif echo $f | grep -q "^ A"; then
            vim  $(echo $f | cut -dM -f2)
        fi
    done
}

# xxxx

gaic () {
    gaii .; gc "$@"
}

gaii () {
    ga --interactive "$@"
}

gcmr () {
    gcm
    git pull --rebase
    bump show
}

gcpc () {
    git cherry-pick --continue
}

gcpe () {
    git cherry-pick --edit "$@"
}

ggai () {
    g -q $1 $2 && gai $2 || echo fuck off
}

glp1 () {
    glp -n1 "$@"
}

gls1 () {
    gls -n1 "$@"
}

gmmm () {
    local _branch=$(git_branch)
    git co master
    grr
    git co $_branch
    gmm
}

grmm () {
    grr
    gmmm
}

# xxxxx

clone () {
    local _clone_log=/tmp/_clone.log
    echo "" > $_clone_log
    git clone "$1"> $_clone_log 2>&1 
    if grep -q fatal $_clone_log; then
        cat $_clone_log
    else
        cd $(grep Cloning.into $_clone_log | sed -e "s/Cloning into '//" -e "s/'.*//")
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
    kd $_there "$@" >/dev/null 2>&1
}

git_root () {
    _there="$1"; shift
    [[ -f "$_there" ]] && _there=$(dirname $_there)
    [[ -d "$_there" ]] || return 1
    (_git_kd "$_there"; git rev-parse --git-dir) >/dev/null 2>&1 || return 1
    local _root=$(_git_kd "$@"; git rev-parse --git-dir 2>/dev/null)
    _root=${_root%%.git}
    if [[ -z $_root ]]; then
        echo $(readlink -f $_there);
    else
        echo $(readlink -f $_root);
    fi
}

# xxxxxxxxxx

_git_stash_and () {
    local stashed=
    if git_changed; then
        stashed=1
        git stash -q
    fi
    git "$@"
    if [[ $stashed == 1 ]]; then
        git stash pop -q
    fi
}

git_branch () {
    git rev-parse --abbrev-ref HEAD
}

# xxxxxxxxxxx

git_changed () {
    local git_dir=$(git_root ${1:-$PWD})
    [[ -n $git_dir ]] || return 1
    git -C $git_dir status --porcelain | gre -q "$_git_status_regexp"
}

# xxxxxxxxxxxx

_git_modified () {
    [[ $(_status_chars $1) == " M" ]]
}

_run_storage () {
    bash $_storage
    rr $_storage
}

# xxxxxxxxxxxxx

_git_untracked () {
    [[ $(_status_chars $1) == "??" ]]
}

_status_chars () {
    git -C $dir status -s -- $1 | sed -e "s/\(..\).*/\1/"
}

_do_git_status () {
    local __doc__="get the status from git"
    dir=$1; shift
    [[ -z $dir ]] && dir=$PWD
    # [[ -d "${dir}/.git" ]] || return
    git -C $dir status "$@"
}

# xxxxxxxxxxxxxx

show_git_time () {
    local _arg_dir="${1:-$PWD}"
    git_dir=$(git_root "$_arg_dir")
    [[ $git_dir == $_arg_dir ]] && _arg_dir=
    [[ -n $git_dir ]] || return 1
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
    [[ -n $git_dir ]] && git -C "$git_dir" status -s 2>/dev/null | grep "$_git_status_regexp"
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
