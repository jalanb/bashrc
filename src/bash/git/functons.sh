#! /bin/cat

. $JAB/bin/first_dir.sh
. $JAB/environ.d/colour.sh

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
        echo 'Did you mean "gal" (add all) ?'
        return 1
    else
        set -x
        git add "$@"
        set +x
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

gs () {
    shift_dir "$@" && shift
    _do_git_status $dir "$@"
}

tc () {
    v ~/.gitconfig +
}

# xxx

aga () {
    git reset HEAD "$@"
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
    ga $addable && gc "$@"
}

gai () {
    ga --patch "$@"
}

gcj () {
    local _storage=/tmp/gcj.sh
    local GIT="git -C $JAB"
    if [[ -z "$@" ]]; then $GIT commit --all --verbose
    else
        python -c "print '$GIT commit -m\"$*\"'" > $_storage
        _run_storage
    fi
}

gcm () {
    git co master
}

gdi () {
    git di "$@"
}

gdh () {
    git dh "$@"
}

gdl () {
    git diff --color=always "$@"| less -r
}

gds () {
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
    local _vertical_lines=${LINES:-$(tput lines)}
    local _one_third_of_vertical=$(( $_vertical_lines / 3 ))
    local _lines=${GIT_LOG_LINES:-$_one_third_of_vertical}
    git $cmd "$@" | head -n $_lines
}

gla () {
    _gl lg --author=Alan.Brogan "$@"
}

glg () {
    local _dit=1
    if [[ $1 =~ [[:digit:]] ]]; then
        $_dit=$1
        shift
    fi
    git log -n${1:-$_dit} -p | head -n $(( LINES / 3 ))
    _gl lg "$@" | _call_me_alan | sed -e "s/ ago//"
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

gpp () {
    echo "Pull"
    grr "$@"
    read -p "Push? [Y]" reply
    [[ -z $reply || $reply == "y" || $reply == "Y" ]] && gpu "$@"
}

_gp () {
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

gpo () {
    gpu  "$@"
}

gpu () {
    _gp push "$@"
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
    _gp pull --rebase "$@"
}

grs () {
    git rerere status
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
    _git_modified $f && git dv $f || v $f
}

_gsi_prompt () {
    _gsi_menu $1
    read -e -n1 -p " " answer
}

gsi () {
    shift_dir "$@" || shift
    for f in $(git -C $dir status -s | grep "^\([M ]M\|??\)" | sed -e "s/^...//")
    do
        [[ -z $f ]] && continue
        _git_modified $f && git di $f || (_git_untracked $f && cat $f || continue)
        _gsi_prompt $f
        if [[ $answer =~ [fF] ]]; then gc; _gsi_prompt $f; fi
        [[ $answer =~ [qQ] ]] && break
        [[ $answer =~ [aA] ]] && ga $f
        [[ $answer =~ [iI] ]] && (_git_modified $f && gai $f || (_git_untracked $f && echo Cannot split untracked file))
        [[ $answer =~ [pP] ]] && (_git_modified $f && gap $f || (_git_untracked $f && echo Cannot split untracked file))
        [[ $answer =~ [dD] ]] && (_git_modified $f && git co $f || (_git_untracked $f && rm -i $f))
        [[ $answer =~ [vV] ]] && _gsi_vim $f
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

ggai () {
    g -q $1 $2 && gai $2 || echo fuck off
}

glp1 () {
    glp -n1 "@"
}

# xxxxx
# xxxxxx
# xxxxxxx

_show_git_here () {
    [[ -d "$PWD/.git" ]] || return
    local days=${1:-5}
    local _log=$(git -C $PWD log -n 1)
    [[ $? ]] && git -C $PWD lg --since="$days days ago"
}

# xxxxxxxx

git_root () {
    root=$(git -C "${1}" rev-parse --git-dir 2>/dev/null) || return 1
    root=${root%%.git}
    if [[ -z $root ]]; then
        echo $1;
    else
        echo $root;
    fi
}

# xxxxxxxxxx

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
    rq $_storage
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
    local lines_left=$(( ${LINES:-$(tput lines)} / 2 ))
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

