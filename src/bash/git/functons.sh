#! /usr/bin/env head -n 3

# This script is intended to be sourced, not run


. ~/bash/arg_dirs.sh
. ~/bash/crayons.sh
. ~/bash/git/gsi.sh
. ~/bash/git/status.sh
. ~/bash/keyboard/r.sh

# functons.sh for git

git_status_char_regexp_="[ MADRCU]"
git_status_regexp_="^${git_status_char_regexp_}${git_status_char_regexp_}"
# sorted by strcmp of function name

# x

# xx

GI () {
    GIT_EDITOR=true gi "$@"
}

ga () {
    [[ -n $GIT_ADDED ]] && GIT_ADDED="$@" || GIT_ADDED="$GIT_ADDED:""$@"
    if [[ -z "$*" ]]; then
        show_error "Nothing specified for add "
        show_error 'Did you mean "gaa" (add all) ?'
        return 1
    else
        show_command git add "$@"
        git add "$@"
    fi
}

gb () {
    local sought_= option_=
    if [[ $1 =~ ^- ]]; then
        option_=$1
        shift
    fi
    sought_="$@"
    if [[ $sought_ ]]; then
        show_command git branch $option_ \| grep $sought_
        grep_branch "$sought_" "$option_" 2>&1 | grep -v -e warning | grep --color $sought_
    else
        show_command git branch $option_
        git branch $option_ 2>&1 | grep -v -e warning
    fi
}

gbg () {
    local option_=
    [[ $1 =~ ^- ]] && option_=$1
    [[ $option_ ]] && shift
    [[ "$@" ]] || return
    show_command git branch $option_ '|' grep $@
    grep_branch "$@" $option_ 2>&1 | grep -v -e warning | grep --color "$@"
}


gc () {
    local quiet_= quietly_=
    [[ $1 =~ [-][qQ] ]] && quiet_=$1 && shift
    [[ $quiet_ =~ [-][Q] ]] && quietly_=Quietly
    if [[ -d "$1" ]]; then
        local dir_="$1" && shift
        [[ $quiet_ ]] || show_command git -C "$dir_" "$@"
        $quietly_ git --no-pager -C "$dir_" "$@"
    else
        [[ $quiet_ ]] || show_command git "$@"
        $quietly_ git --no-pager "$@"
    fi
}

gd () {
    green_line g d "$@"
    g d "$@"
    return 4
}

gf () {
    gft; gfa
}
alias fetch_tags_all=gf

gi () {
    local _doc___="git in"
    if [[ "$@" ]]; then
        local storage_=/tmp/gi.sh
        python -c "print('git commit -m\"$*\"')" > $storage_
        cat $storage_
        bash $storage_
        rm -f $storage_
    else
        git commit --verbose
    fi
    GIT_ADDED=
}

gl () {
    gl_ 4 "$@"
}

gm () {
    git merge --no-ff --no-edit "$@"
}

go () {
    local _doc___="git checkout"
    local stashed_=
    local current_branch_=$(get_branch) wanted_branch_="${@##*/}"
    show_command git checkout $wanted_branch_
    [[ "$wanted_branch_" == $current_branch_ ]] && show_error "Already on $current_branch_"
    [[ "$wanted_branch_" == $current_branch_ ]] && return 0
    if any_git_changes_ .; then
        show_error "Cannot checkout $wanted_branch_"
        show_error "Please clean the index first:"
        git status
        return 1
    fi
    git checkout -q "$wanted_branch_"
    return 0
}

gp () {
    show_command git push "$@"
    if ! MSG=$(git push "$@" 2>&1); then
        if [[ $MSG =~ set-upstream ]]; then
            local command_=$(echo "$MSG" | grep set-upstream)
            $command_
        elif [[ $MSG =~ current.branch.does.not.match ]]; then
            show_command git push origin HEAD
            git push origin HEAD
        else
            show_error "$MSG"
            return 1
        fi
    fi
}

gs () {
    local _doc___="""git status front end"""
    gc "$@" status 2>/dev/null 
}

gt () {
    if [[ $* ]]; then
        local tag_=
        for tag_ in "$@"; do
            git tag $tag_
        done
    else
        git tag | sort
    fi
}

gw () {
    if [[ $1 ]]; then
        git config alias.$1
    else
        vv ~/.gitconfig +/alias
    fi
}

gdf () {
    git "$@" df
}

gof () {
    gbD fred 2>/dev/null
    gob fred "$@"
}

# xxx

gaa () {
    ga .
}

gac () {
    ga "$@"
    gcpc
}

gai () {
    local _doc___="""Add args interactively"""
    git add --patch "$@"
}

gba () {
    gbr "$@"
    gb "$@"
}

gbaa () {
    git branch -a "$@"
}

gbb () {
    git_branch "$@"
}

gbc () {
    git branch --contains "$@"
}

gbr () {
    gb -r "$@"
}

gbs () {
    gb "$@"
    gs
}

gbt () {
    gb "$@"
    gt "$@"
}

gbd () {
    if [[ $1 =~ [-][yY] ]]; then
        shift
        echo y | gbd_ -d "$@"
    else
        gbd_ -d "$@"
    fi
}

gbD () {
    if [[ $1 =~ [-][yY] ]]; then
        shift
        echo y | gbd_ -D "$@"
    else
        gbd_ -D "$@"
    fi
}

gbo () {
    gba "$@" | grep origin
}

gbm () {
    git branch -m "$@"
}

gbv () {
    git blame "$1" | vin
}

gcc () {
    local c_="." d_=
    [[ -d $1 ]] && c_=$1 && d_=d
    [[ $d_ == d ]] && shift
    echo $c_ 
    [[ $d_ == d ]] && return 0
    return 1
}


gcl () {
    local c_=$(gcc "$@") && shift
    gc $c_ l "$@"
}

gcp () {
    show_command git cherry-pick -x --allow-empty "$@"
    git cherry-pick -x --allow-empty "$@"
}

gcs () {
    local c_=$(gcc "$@") && shift
    gc "$c_" s
}

gcu () {
    show_command git config user.name
    show_command git config user.email
    echo "$(git config user.name) "'<'"$(git config user.email)"'>'
}

gdd () {
    gdi .
}

gdf () {
    gc "$@" df
}

gdi () {
    gc "$@" d
}

gdh () {
    gc "$@" dh
}

gdl () {
    git diff --color=always "$@"| fewer
}

gds () {
    local diff_=${1:-diff}
    git $diff_ --staged "$@"
}

gdv () {
    local dir_=.
    if [[ -d "$1" ]]; then
        dir_="$1"
        shift
    fi
    [[ $1 ]] || return 1
    (cd $dir_; [[ -f "$1" ]] || return 2)
    gc "$dir_" dv "$1"
}

gfa () {
    show_command git fetch --prune --all
    git fetch --prune --all
}

gfe () {
    gfa
    [[ $1 == -f ]] && grupp || grup
}

gff () {
    local main_branch_=$(main_branch)
    [[ $1 ]] && main_branch_=$1
    gru
    gcu
    show_command git_root -o
    gfe "$@" | grep -v 'Fetching'
    gba
    gor $main_branch_ 2>/dev/null | grep -v -e "up to date" -e Already
    show_command bump show
    bump show
    gll
}

gfff () {
    gff -f
}

gfm () {
    gfe
    gomr
}

gft () {
    git fetch --tags --force --all
}

gia () {
    show_command git commit --amend "$@"
    GIT_EDITOR=true git commit --amend "$@"
}

gie () {
    git commit --amend --edit "$@"
}

gip () {
    gi "$@"
    gp
}

gl_ () {
    local options_="-n 8"
    if [[ $1 =~ ^[1-9][0-9]*$ ]]; then
        options_="-n $1"
        shift
    fi
    if [[ $1 =~ ^--* ]]; then
        if [[ $1 =~ ^--since ]]; then
            options_="$1"
        else
            options_="$options_ $1"
        fi
        shift
    fi
    if [[ $1 ]]; then
        if git branch --all | grep -q $1; then
            options_="$options_ $1"
            shift
        fi
    fi
    gc "$@" l $options_
}

gl1 () {
    gl_ 1 "$@"
}

gl2 () {
    gl_ 2 "$@"
}

gl3 () {
    gl_ 3 "$@"
}

gl4 () {
    gl_ 4 "$@"
}

gla () {
    gc "$@" l --author=Alan.Brogan
}

glg () {
    local sought_=$1; shift
    gc "$@" l --grep "$sought_" 2>/dev/null
    local result_=$?
    echo
    return $result_
}

gll () {
    gl_ 8 "$@"
}

glm () {
    g l __main__^..
}

gln () {
    gc "$@" l --name-only
}

glp () {
    gl -p "$@"
}

glt () {
    gc "$@" lt
}

glv () {
    git lg --color=never "$@" | vim -
}

gma () {
    git merge --abort
}

gmm () {
    local branch_=$(get_branch) main_branch_=$(main_branch)
    go $main_branch_
    grr
    go $branch_
    gm $main_branch_
}

gmt () {
    git merge --no-ff --no-edit -X theirs "$@"
}

gob () {
    local new_branch_=$(to_branch_ "$1") old_commit_=$2
    shift 2
    [[ $new_branch_ ]] || return 1
    [[ $old_commit_ ]] || old_commit_=$(get_branch)
    git checkout -b $new_branch_ $old_commit_
}

gof () {
    gbD fred 2>/dev/null
    gob fred "$@"
}

gog () {
    go "$@"; glg; bump show
}

gol () {
    go "$@"
    gl
}

gom () {
    local main_branch_=$(main_branch) source_=$(get_branch)
    [[ $source_ == $main_branch_ ]] && return
    go $main_branch_ "$@"
}

goo () {
    local path_="."
    [[ "$@" ]] && path_="$@"
    show_command git restore --staged "$path_"
    git restore --staged "$path_"
    show_command git restore "$path_"
    git restore "$path_"
    show_command git status --porcelain "$path_"
    git status --porcelain "$path_"
}

gor () {
    if git_changes_here; then
        red_line "Please handle changes first" >&2
        git status --short
        return 1
    fi
    for branch in "$@"; do
        go "$branch"
        show_command git pull --rebase
        git pull --rebase -q
    done
}

got () {
    if grep_branch "$1" -a -q ; then
        gor "$@"
    else
        git "$@"
    fi
}

gpf () {
    show_command git push --force-with-lease "$@"
    if ! MSG=$(git push --force-with-lease "$@" 2>&1); then
        if [[ $MSG =~ set-upstream ]]; then
            local command_=$(echo "$MSG" | grep set-upstream | sed -e "s:push :push --force :")
            $command_
        else
            show_error "$MSG"
            return 1
        fi
    fi
}

gpo () {
    show_command git push origin "$@"
    git push origin "$@"
}

gpp () {
    gpf "$@" && gpt
}

gps () {
    git_stash_and gp "$@"
}

gpt () {
    gpo --tags
}

gra () {
    git rebase --abort
}

grl () {
    show_command git pull --rebase
    git pull --rebase "$@"
    show_command git log -n $(( $LINES / 2 ))
    git l -n $(( $LINES / 2 ))
}

grr () {
    show_command git pull --rebase
    git pull --rebase "$@"
}

dir_has_branch () {
    is_branch "$@"
}

main_branch () {
    if grep_branch -r -q __main__; then
        echo __main__
        return 0
    fi
    if grep_branch -q master; then
        grep_branch master
        return 0
    elif grep_branch -r -q master; then
        grep_branch -r master
        return 0
    fi
    return 1
}

show_branch () {
    git_branch -v "$@"
}

minus_one () {
    local int_=$1
    echo $(( $int_ - 1 ))
}

branches () {
    local needed_=$1 branch_=
    for branch_ in "$*"; do
        test $needed_ -le 0 && return 0
        is_branch $branch_ . || continue
        echo $branch_
        needed_=$(minus_one $needed_)
    done
    return 1
}

giddy () {
    local dir_=.
    [[ -d "$1" ]] && dir_="$1" && shift
    git -C "$dir_" "$@"
}

grb () {
    local branch_= main_branch=$(mains 1 "$@")
    [[ $main_branch ]] || main_branch=$2
    [[ $main_branch ]] || echo "No masters available, usage: grb branch upstream"
    [[ $main_branch ]] || return 1

    git rebase $main_branch $branch_
}

grc () {
    show_command git rebase --continue
    GIT_EDITOR=true git rebase --continue | grep "skip this commit" || return
    git rebase --skip
}

grf () {
    local branch_=__main__
    [[ $1 ]] && branch_=$1
    gru
    gcu
    show_command git_root -o
    git_root -o
    gfe | grep -v 'Fetching'
    gor $branch_ 2>/dev/null | grep -v "up to date"
    gb
    show_command bump show
    bump show
    gll
}

grg () {
    git e && glg
}

grh () {
    git reset HEAD "$@"
}

gri () {
    local _doc___="""Rebase args interactively"""
    local args_="HEAD~2"
    [[ "$@" ]] && args_="$@"
    git rebase --interactive $args_
}

grm () {
    local __doc__="""git rebase main branch onto $1, or checked out branch"""
    local main_branch=$(main_branch)
    grbb $main_branch "$@"
}

gbac () {
    show_command git branch --all --contains "$@"
    git branch --all --contains "$@"
}

grbb () {
    local __doc__="""git rebase $1 onto $2, or checked out branch"""
    local upstream_=$1 branch_=$(get_branch)
    shift
    if [[ $1 ]]; then
        local one_=$1
        local one_branch_=$(list_branches $one_ | head -n 1)
        if [[ ! $one_branch_ ]]; then
            local one_remote_=$(list_branches -r $one_ | head -n 1)
            if [[ $one_remote_ ]]; then
                one_branch_=$one_remote_
                git checkout $one_branch_
            fi
        fi
        if [[ $one_branch_ ]]; then
            branch_="$one_branch_"
            shift
        fi
    fi
    [[ $branch_ == $upstream_ ]] && echo "Already on $upstream_" >&2
    [[ $branch_ == $upstream_ ]] && return 1
    show_command git rebase $upstream_ $branch_
    git rebase $upstream_ $branch_
}

gro () {
    local origin_=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
    if [[ -n $origin_ ]]; then
        echo $origin_
        return 0
    fi
    show_error No origin
    return 1
}

grp () {
    if grr "$@"; then
        read -p "Push? [Y]" reply
        [[ -z $reply || $reply == "y" || $reply == "Y" ]] && gpp "$@"
    fi
}

grr () {
    git pull --rebase "$@"
}

grim () {
    gri $(main_branch)
}

grrr () {
    git_stash_and grr "$@"
}

grs () {
    git rebase --skip
}

gru () {
    local c_= quiet_= arg_=
    for arg_ in "$@"; do
        [[ -d "$arg_" ]] && c_="-C ""$arg_"
        [[ $arg_ =~ [-]q ]] && quiet_=1
    done
    local args_="$c_ remote get-url origin"
    [[ $quiet_ ]] || show_command git $args_
    git $args_
}

gsa () {
    git_stash_and "$@"
}

gsb () {
    gs
    gb
}

gsg () {
    gs
    glg
}

gss () {
    local _doc___="""git short status"""
    gc "$@" status --short 2>/dev/null 
}

gso () {
    git_stash_and go "$@"
}

gsp () {
    local _doc___="""Porcelain status"""
    gc "$@" status --porcelain 2>/dev/null 
}

gta () {
    gt "$@"
}

gtd () {
    git tag -d "$@"
}

gtD () {
    gpod "$@"
}

gtl () {
    if [[ "$@" ]]; then 
        gt --list | grep "$@"
    else
        gt --list
    fi
}

gvd () {
    local _doc___="""vim diff all changed files"""
    shift_dir "$@" && shift
    for f in $(git_status_line_dir $dir_ | grep "^ M" | cut -dM -f2)
    do
        git dv $f
    done
    QUESTIONS=$(untracked $dir_)
    [[ -n $QUESTIONS ]] && v $QUESTIONS
}

gipf () {
    gi "$@"
    gpf
}

gpff () {
    gp --force "$@"
}

# xxxx

gbd_ () {
    local current_branch_=$(get_branch) options_=
    local main_branch_=$(main_branch)
    local delete_branch_=$current_branch_
    if [[ "$@" =~ $current_branch_ ]]; then
        if [[ "$@" == "$main_branch_" ]]; then
            git checkout $(git tag --list  | sort -V | tail -n 1)
            current_branch_=$(get_branch)
            if [[ $current_branch_ == "$main_branch_" ]]; then
                show_error Please checkout another branch before deleting $main_branch_
                return 1
            fi
        else
            gom
        fi
    elif [[ "$1" =~ ^-[dD]$ ]]; then
        options_="$1"
        shift
        local arg_= branches_=
        for arg_ in "$@"; do
            is_branch $arg_ || continue
            branches_="$branches_ $arg_"
        done
        [[ "$branches_" ]] && delete_branch_="$branches_"
        if [[ $delete_branch_ == "$main_branch_" ]]; then
            show_error Please checkout another branch before deleting $main_branch_
            return 1
        fi
        local answer_=N
        if [[ $delete_branch_ == "fred" ]]; then
            answer_=Y
        else
            if [[ "$1" =~ ^-[yY]$ ]]; then
                answer_=Y
                shift
            else
                read -p "OK to remove $delete_branch_ [y]? " -n1 answer_
                echo
            fi
        fi
        [[ -n $answer_ && ! $answer_ =~ [yY] ]] && return 1
        if git status 2>&1 | grep -q git.merge...abort; then
            gma
        fi
        gom
        show_command git branch "$options_" $delete_branch_
        git branch "$options_" $delete_branch_
        return 0
    fi
    show_command git branch "$@"
    git branch "$@"
}

gbac () {
    git branch --all --contains "$@"
}

gbdd () {
    local branch_=
    for branch_ in $(grep_branch -v -e __main__ -e master); do
        if mastered $branch_; then
            gbd $branch_
        fi
    done
}

gbdr () {
    gbD
    git e
}

gbDD () {
    local delete_branch_=$(get_branch)
    [[ "$@" ]] && delete_branch_="$@"
    gbD "$@"
    gpod $delete_branch_
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

gcua () {
    local_gcu 'Alan Brogan' $(work_email alan.brogan)
}

gcuh () {
    local_gcu jalanb $(al_email github)
}

gcug () {
    local_gcu 'Git Lab' $(work_email gitlab)
}

alias gcuj=gcuh

gcus () {
    local_gcu 'Sparky' $(work_email alan.brogan)
}

gcuw () {
    local_gcu 'Alan Brogan' $(work_email ab13173)
}

gdil () {
    gdi | less -R
}

gdis () {
    gc d --staged  "$@"
}

glgg () {
    local stdout_=~/fd1 stderr_=~/fd2
    show_command gc lg "$@" > $stdout_
    gc lg "$@" >> $stdout_ 2> $stderr_ 
    [[ $? == 0 ]] && (cat $stderr_; return 1)
    local count_=$(wc -l $stdout_)
    if [[ $count_ < $(( $LINES - 2 )) ]]; then gc lg "$@"
    elif [[ $count_ < 256 ]]; then less -R $stdout_
    else tput smcup; gc lg "$@"; tput rmcup
    fi
}

glgo () {
    glg origin/"$@"
}

glll () {
    gl_ 16 "$@"
}

godr () {
    gor development
    bump show
}

gomb () {
    gob "$@" master
}

gomr () {
    gom
    show_command git pull --rebase
    git pull --rebase
    bump show
}
alias pull_main=gomr

gooo () {
    goo .
}

gorl () {
    gor "$@"
    glg
}

gcpa () {
    show_command git cherry-pick --abort
    git cherry-pick --abort
}

gcpc () {
    show_command git cherry-pick --continue
    GIT_EDITOR=true git cherry-pick --continue
}

gcpe () {
    show_command git cherry-pick --edit "$@"
    git cherry-pick --edit "$@"
}

gdsi () {
    gds di "$@"
}

gdsv () {
    gds dv "$@"
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
    glp -n 1 "$@"
}

glf1 () {
    git lg -n 1 "$@"
    git lg -n 1 --compact-summary "$@" | kat -f 2 -l -2 | cut -d'|' -f2
}

gls1 () {
    gls -n 1 -l 31 "$@"
}

gpod () {
    local arg_= branch_= branches_=
    for arg_ in "$@"; do
        branch_=$(echo $arg_ | sed -e "s:.*origin/::")
        branches_="$branches_ $branch_"
    done
    gpo --delete $branches_
}

gppp () {
    gpf "$@" && gpt
}

gpsu () {
    git push --set-upstream origin "$@"
}

grmt () {
    local current_branch_=$(get_branch)
    git rebase master $current_branch_ -X theirs
}

grup () {
    show_command git remote update origin --prune
    git remote update origin --prune
    grep_branch -q '^fred$' && git branch -D fred
    show_command git fetch --tags --force --prune-tags --prune origin "refs/tags/*:refs/tags/*"
    git fetch --tags --force --prune-tags --prune origin "refs/tags/*:refs/tags/*"
}

grupp () {
    grup
    show_command git gc --prune=now --aggressive
    git gc --prune=now --aggressive 2>&1 | grep -v -e objects -e ' reused '
    show_command git repack -a -d
    git repack -a -d 2>&1
}

gsri () {
    git_stash_and gri "$@"
}

git_status_line_dir () {
    local dir_="$1"; shift
    git -C $dir_ "$@" status --short
}
alias gssd=git_status_line_dir

git_stash_branch () {
    local branch_=$1
    [[ $branch_ ]] || branch_=fred && shift
    [[ $branch_ == 'fred' ]] && Quietly git branch -D fred
    git stash branch $branch_ "$@"
}
alias gstb=git_stash_branch

git_stash_list () {
    git stash list
}
alias gstl=git_stash_list

git_stash_pop () {
    git stash pop
}
alias gstp=git_stash_pop

gtdd () {
    local tag_=
    for tag_ in "$@"; do
        gtd "$tag_"
        gtD "$tag_"
    done
}

gtlg () {
    gtl | grep "$@"
}

gurl () {
    grep https .git/config | sed -e "s:url =::" | grep git.*
}

rgl_ () {
    gl_ "$@"
}

# xxxxx

clonn () {
    local name_=${1:-pysyte}
    [[ $name_ ]] || return 12
    local here_=`readlink -f .`
    local dir_=`dirname $here_`
    local url_="https://github.com/jalanb/${name_}.git"
    local pwd_=`pwd`
    if [[ -d $name_ ]]; then
        cd $name_
        local gurl_=`git remote get-url origin`
        [[ $url_ == $gurl_ ]] || return 15
        pwd
        return 0
    elif [[  $name_ =~ pysy.e ]]; then
        [[ $dir_ == pysyse ]] || return 13
        clone $url_
        return 0
    elif [[ $dir_ == jalanb ]]; then
        clone $url_
        return 0
    else
        local dest_="$HOME/jalanb"
        [[ $name_ =~ pysy.e ]] && dest_="$dest_/pysyse"
        cd $dest_
        clonn $name_
    fi
}

clone () {
    local range_=
    [[ "$1" == "-r" ]] && range_=ranger
    local remote_=
    [[ -n $1 ]] && remote_=$1 && shift
    local local_=
    [[ -n $1 ]] && local_=$1 && shift

    local clone_log_=/tmp/clone_.log
    echo "" > $clone_log_
    git clone $remote_ $local_ > $clone_log_ 2>&1
    if grep -q fatal $clone_log_; then
        # kat -n $clone_log_
        cat -n $clone_log_
    else
        cd $(grep Cloning.into $clone_log_ | sed -e "s/Cloning into '//" -e "s/'.*//")
        if [[ $remote_ =~ $(work) ]]; then
            git config --local user.name "Alan Brogan"
            git config --local user.email $(work_email alan.brogan)
        fi
        runnable $range_ && $range_
    fi
}

glggo () {
    glgg origin/"$@"
}

gorll () {
    gor "$@"
    git lg
}

gllll () {
    gl_ 32 "$@"
}

glllll () {
    gl_ 64 "$@"
}

gllllll () {
    gl_ 128 "$@"
}

glllllll () {
    gl_ 256 "$@"
}

gllllllll () {
    gl_ 512 "$@"
}

glllllllll () {
    gl_ 1024 "$@"
}

glone () {
    local _doc___="""pronounced 'g l one'"""
    gl --oneline "$@"
}

# xxxxxx
# xxxxxxx

standup () {
    for dir in $(fd -H -td .git ~/lab/alan/ -X dirname)
    do
        if git -C $dir standup | grep -q nothing; then
            if [[ $(git -C $dir status --porcelain) ]]; then
                ( 
                    show_command cd $dir
                    cd $dir
                    ls -ltc --time-style=+"xxx%a %b %d%Y" $(git status --porcelain | sed -e "s,...,," -e "s,.*-> ,,") | sed -e "s/.*xxx/ /g" -e "/^total/d"
                )
                echo; echo
            fi
            continue
        fi
        gc $dir standup;
        gc $dir status --short
        echo; echo
    done
}

git_kd_ () {
    cde "$@" > ~/fd1 2> ~/fd2
}

# xxxxxxxx

mastered () {
    local main_branch_=$(main_branch)
    has_branch $main_branch_ "$1" || has_branch $main_branch_ origin/$1
}

show_pre_loop_ () {
    green_line local
    show_this_branch
    green_line status
}

get_root () {
    git_root -q "$@" 2>/dev/null
}

git_root () {
    local git_dir_=
    local origin_=
    local quiet_=
    local verbose_=
    for arg_ in $*; do
        if [[ -e "$arg_" ]]; then
            git_dir_="$arg_"
            shift
            break
        fi
        [[ $arg_ == -o ]] && origin_=yes
        [[ $arg_ == -q ]] && quiet_=yes
        [[ $arg_ == -v ]] && verbose_=yes
    done
    [[ $origin_ ]] && verbose_=yes
    [[ $verbose_ ]] && quiet_=
    [[ $git_dir_ ]] || git_dir_=$(readlink -f .)
    [[ -f "$git_dir_" ]] && git_dir_=$(dirname_ $git_dir_)
    [[ -d "$git_dir_" ]] || echo "Not a dir '$git_dir_'"
    [[ -d "$git_dir_" ]] || return 1
    local dir_=$(readlink -f $git_dir_)
    if ! git -C "$dir_" rev-parse --git-dir > /tmp/fd1 2>/tmp/fd2; then
        cat /tmp/fd1
        cat /tmp/fd2 >&2
        return 1
    fi
    [[ $quiet_ ]] || show_command git -C "$dir_" rev-parse --show-toplevel
    git -C "$dir_" rev-parse --show-toplevel
}

# xxxxxxxxx

git_stash () {
    local _doc___="""git stash"""
    gc "$@" stash
}

git_dirty () {
    git -C $1 status | grep -v -e 'On branch' -e '^$' -e 'branch is up to date' -e 'working tree clean' | grep -q .
}

local_gcu () {
    local name_="$1"
    shift
    local email_="$1"
    shift
    git config --local user.name "$name_"
    git config --local user.email "$email_"
}

# xxxxxxxxx_

to_branch_ () {
    echo "$1" | tr ' ' '_'
}
# xxxxxxxxxx

has_branch () {
    git branch --contains $1 2>/dev/null | grep -q $2
}

git_stash_and () {
    local stashed_=
    if git_changes_here; then
        show_command git stash
        git stash -q
        stashed_=1
    fi
    "$@"
    local result_=$?
    if [[ $stashed_ == 1 ]]; then
        git_stash_pop -q
    fi
    return $result_
}


is_branch () {
    [[ $1 ]] || return 1
    get_branch $1 >/dev/null
}

get_branch () {
    git_branch -q "$@"
}

git_branch () {
    local show_=show_run_command ref_=HEAD
    [[ $1 == -q ]] && show_=
    [[ $1 == -q ]] && shift
    [[ $1 == -v ]] && show_=show_run_command
    [[ $1 == -v ]] && shift
    [[ "$@" ]] && ref_=$1
    $show_ git rev-parse --abbrev-ref $ref_ 2> /dev/null || return 1
}

sed_origin () {
    git remote set-url origin $(git remote get-url origin | sed "$@")
}

show_clone () {
    local head_='===-===-==='
    local dir_="$1"
    [[ $dir_ ]] || dir_=.
    [[ -d "$dir_/.git" ]] || return 1
    local git_="git -C $dir_"
    echo
    blue_line $head_
    green_line $head_
    green_line "$($git_ remote get-url origin) -> " $(rlf "$dir_")
    green_line $head_
    local status_=$($git_ status --porcelain)
    if [[ $status_ ]]; then
        red_line $head_
        red_line $status_
        red_line $head_
    fi
    green_line $head_
    $git_ ll
    green_line $head_
    blue_line $head_
}

# xxxxxxxxxxx

clean_clone () {
    local main_branch_=$(main_branch)
    git reset head .
    git checkout .
    git clean -f -d -f
    git fetch --all
    git checkout $main_branch_
    for branch in $(git branch --format="%(refname:short)" | grep -v -e __main__ -e master -e deployed-to); do
        [[ -f $branch ]] && continue
        git branch -d $branch 2>/dev/null
    done
    echo; echo
    pwd
    g b
    g s
}

git_changes_here () {
    has_git_changes_ .
}

# xxxxxxxxxxxx

# xxxxxxxxxxxxx

untracked () {
    local path_="$1"; shift
    ( test -d "$path_" && git_status_line_dir "$path_" || status_line_ "$path_" ) | grep "??" | cut -d' ' -f2
}

# xxxxxxxxxxxxxx

quietly () {
    "$@" 2>/dev/null
}

Quietly () {
    "$@" >/dev/null
}

QUIETLY () {
    quietly "$@" >/dev/null
}

in_repo () {
    git rev-parse --is-inside-work-tree
}

list_branches () {
    local __doc__="""glob the last arg as a branch name, avoiding prefixes: just the name"""
    local option_=
    if [[ $1 =~ ^[-][ar] ]]; then
        option_=$1
        shift
    fi
    git branch $option_ --list '*'"${1}"'*' --format='%(refname:short)'
}

grep_branch () {
    local regexp_= git_options_= grep_options_=
    while [[ $1 ]]; do
        if [[ $1 =~ ^-[aqrv] ]]; then
            [[ $1 =~ ^-[ar] ]] && git_options_="$git_options_ $1"
            [[ $1 =~ ^-[qv] ]] && grep_options_="$grep_options_ $1"
        else
            regexp_=$1
        fi
        shift
    done
    git branch $git_options_ | sed -e "/HEAD/d" -e "s,^[ *]*,," | grep $grep_options_ "$regexp_"
}

show_git_time () {
    local arg_dir_="${1:-$PWD}"
    git_dir=$(git_root "$arg_dir_")
    [[ $git_dir == $arg_dir_ ]] && arg_dir_=
    if [[ -n $git_dir ]]; then
        echo
        return 1
    fi
    local log_=
    local period=
    local lines_left=$(( ${LINES:-$(screen_height)} / 2 ))
    for period in seconds minutes hours days weeks "month | grep -v year" year
    do
        regexp=$period.ago
        log_=$(show_git_time_log_ $regexp $arg_dir_)
        if [[ -n $log_ ]]; then
            period_lines=$(show_git_time_log_ $regexp $arg_dir_ | wc -l)
            show_git_time_log_ $regexp $arg_dir_ | trim_git_lines | head -n $lines_left
            [[ $period_lines -gt $lines_left ]] && break
            lines_left=$(( lines_left - $period_lines ))
        fi
    done
    echo
}

# xxxxxxxxxxxxxxx

any_git_changes_ () {
    local _doc___="whether the current dir has modified or untacked files"
    local dir_=$1
    [[ -z $dir_ ]] && dir_=$PWD
    [[ -d "${dir_}/.git" ]] || return 1
    git -C $dir_ status --porcelain | grep "$git_status_regexp_"
}

has_git_changes_ () {
    local dir_=$1
    local files_=$(any_git_changes_ $dir_)
    [[ -n $files_ ]]
}

# xxxxxxxxxxxxxxxx

# xxxxxxxxxxxxxxxxx

git_simple_status () {
    local arg_dir="${1:-$PWD}"
    has_git_changes_ $arg_dir || return 1
    local git_dir_=$(git_root "$arg_dir")
    [[ -d $git_dir_ ]] && git_status_line_dir "$git_dir_" 2> ~/fd2 | grep "$git_status_regexp_"
}

show_git_time_log_ () {
    if [[ -z $2 ]]; then
        git -C $git_dir lg > /dev/null | grep $1
    else
        git lg "$2" > /dev/null | grep $1
    fi
}

# xxxxxxxxxxxxxxxxxxxxxx

call_me_alan_ () {
    sed \
        -e "s/.*al-got-rhythm.net/jalanb/" \
        -e "s/$(work_email '.*')/Alan Brogan/" \
        -e "s/J Alan Brogan/Alan/" \
        "$@"
}

grep_git_log_for_python_test_file ()
{
    local number_=$1; shift;
    gl --stat -n $number_ | grep test_[a-z_]*.py | sed -e "s/\.py .*/.py/"
}

log_test_file ()
{
    grep_git_log_for_python_test_file 3
}

