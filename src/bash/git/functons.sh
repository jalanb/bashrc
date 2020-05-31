#! /bin/cat


. ~/jab/src/bash/crayons.sh
. ~/jab/src/bash/arg_dirs.sh
. ~/jab/src/bash/keyboard/r.sh

# functons.sh for git

git_status_char_regexp_="[ MADRCU]"
git_status_regexp_="^${git_status_char_regexp_}${git_status_char_regexp_}"
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
    local sought_= option_=
    if [[ $1 =~ ^- ]]; then
        option_=$1
        shift
    fi
    sought_="$@"
    if [[ $sought_ ]]; then
        show_command "git branch $option_ | grep $sought_"
        git branch $option_ 2>&1 | grep -v -e warning | grep --color $sought_
    else
        show_command "git branch $option_"
        git branch $option_ 2>&1 | grep -v -e warning
    fi
}

gd () {
    show_run_command git diff "$@"
}

gf () {
    gfa
    gft
}

GI () {
    GIT_EDITOR=true gi "$@"
}

gi () {
    local _doc___="git in"
    if [[ "$@" ]]; then
        local storage_=/tmp/gi.sh
        show_command "$@"
        python -c "print('git commit -m\"$*\"')" > $storage_
        cat $storage_
        bash $storage_
        rr $storage_
    else
        show_run_command git commit --verbose
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
    local _doc___="git checkout"
    local stashed_=
    local current_branch_=$(get_branch) wanted_branch_="${@//origin\/}"
    [[ "$wanted_branch_" == $current_branch_ ]] && show_error "Already on $current_branch_"
    [[ "$wanted_branch_" == $current_branch_ ]] && return 0
    show_command "git checkout $wanted_branch_"
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
    show_command "git push $@"
    if ! MSG=$(git push "$@" 2>&1); then
        if [[ $MSG =~ set-upstream ]]; then
            local command_=$(echo "$MSG" | grep set-upstream)
            show_run_command $command_
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
    local _doc___="""git status front end"""
    gs_ "$@"
}

gt () {
    local tag_=
    for tag_ in "$@"; do
        show_run_command git tag $tag_
    done
    [[ $tag_ ]] || git tag | sort
}

tc () {
    local global_config_=; test -f ~/.gitconfig && global_config_=~/.gitconfig
    local global_ignore_=; test -f ~/.gitignore_global && global_ignore_=~/.gitignore_global
    local local_config_=; test -f .git/config && local_config_=.git/config
    local local_ignore_=; test -f .gitignore && local_ignore_=.gitignore
    local local_creds_=; test -f ~/.git-credentials && local_creds_=~/.git-credentials
    test -f ~/.git-credentials.more && local_creds_="$local_creds_ ~/.git-credentials.more"
    vim -p $global_config_ $global_ignore_ $local_ignore_ $local_config_ $local_creds_
}

ts () {
    tig status
}

# xx_

gs_ () {
    local _doc___="""git status back end"""
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
    local _doc___="""Add args interactively"""
    show_run_command git add --patch "$@"
}

gba () {
    gb -a "$@"
}

gbb () {
    git_branch "$@"
}

gbc () {
    show_run_command git branch --contains "$@"
}

gbr () {
    gb -r "$@"
}

gbt () {
    gb "$@"
    gt "$@"
}

gbd () {
    gbd_ -d "$@"
}

gbD () {
    gbd_ -D "$@"
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

gcu () {
    show_command git config user
    echo "$(git config user.name) "'<'"$(git config user.email)"'>'
}

gdd () {
    gdi .
}

gdf () {
    git df "$@"
}

gdi () {
    local _doc___="""git di args"""
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

gfa () {
    show_run_command git fetch --prune --all
}

gfe () {
    gfa
    grup
}

gff () {
    gcu
    git_root -o
    gfe | grep -v 'Fetching'
    gor master 2>/dev/null | grep -v "up to date"
    gb
    bump show
    local lines_=5
    [[ $1 =~ [0-9]+ ]] && lines_=$(( $1 + 3 ))
    glg $lines_ | grep -v -e 'nothing to commit' -e 'On branch'
}

gfm () {
    gfe
    gomr
}

gft () {
    show_run_command git fetch --tags --force
}

ggi () {
    local _doc___="""Me neither"""
    gxi gdis_ ggi_response_ "$@"
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
    local _doc___="""pronounced 'g l one'"""
    gl --oneline "$@"
}

gla () {
    git_log_to_screen lg --author=Alan.Brogan "$@"
}

glf () {
    local number_='-n 3'
    [[ "$@" =~ -n ]] && number_=
    git lf $number_ "$@"
}

glg () {
    local number_of_commits_=8
    git_log_lines_to_screen -n $number_of_commits_ "$@" 2>/dev/null
    local result_=$?
    echo
    return result
}

gll () {
    git ll "$@"
}

gln () {
    git_log_to_screen lg --name-only "$@"
}

glp () {
    gl -p "$@"
}

gls () {
    git_log_to_screen log --stat "$@"
}

glt () {
    git_log_to_screen lt "$@"
}

glv () {
    git lg --color=never "$@" | vim -
}

gma () {
    show_run_command git merge --abort
}

gmm () {
    local branch_=$(get_branch)
    go master
    grr
    go $branch_
    gm master
}

gmt () {
    show_run_command git merge --no-ff --no-edit -X theirs "$@"
}

gob () {
    local new_branch_=$(to_branch_ "$1") old_commit_=$2
    shift 2
    [[ $new_branch_ ]] || return 1
    [[ $old_commit_ ]] || old_commit_=$(get_branch)
    show_run_command git checkout -b $new_branch_ $old_commit_
}

gof () {
    gbD fred 2>/dev/null
    gob fred "$@"
}

gog () {
    go "$@"; glg; bump show
}

gom () {
    go master "$@"
}

goo () {
    go .
}

gor () {
    if git_changed; then
        show_red_line "Please handle changes first" >&2
        git status --short
        return 1
    fi
    for branch in "$@"; do
        go "$branch"
        gr
    done
}

got () {
    if git branch -a | grep $1; then
        gor "$@"
    else
        show_run_command git "$@"
    fi
}

gpf () {
    show_command "git push --force-with-lease $@"
    if ! MSG=$(git push --force-with-lease "$@" 2>&1); then
        if [[ $MSG =~ set-upstream ]]; then
            local command_=$(echo "$MSG" | grep set-upstream | sed -e "s:push :push --force :")
            show_run_command $command_
        else
            show_error "$MSG"
            return 1
        fi
    fi
}

gpo () {
    show_run_command git push origin "$@"
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

show_pre_loop_ () {
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
    gr && glg
}

grh () {
    show_run_command git reset HEAD "$@"
}

gri () {
    local _doc___="""Rebase args interactively"""
    local args_="HEAD~2"
    [[ "$@" ]] && args_="$@"
    show_run_command git rebase --interactive $args_
}

grm () {
    local upstream_=master
    local branch_=$(get_branch)
    if [[ $1 ]]; then
        local one_=$1
        local one_branch_=$(git branch | grep "^[ ]*[^ ]*$one_[^ ]*$" | head -n 1)
        if [[ ! $one_branch_ ]]; then
            local one_remote_=$(git branch --remotes | sed -e "s:origin/::" | grep $one_ | head -n1)
            if [[ $one_remote_ ]]; then
                one_branch_=$one_remote_
                git co $one_branch_
            fi
        fi
        if [[ $one_branch_ ]]; then
            branch_="$one_branch_"
            shift
        fi
    fi
    [[ $branch_ == $upstream_ ]] && echo "Already on $upstream_" >&2
    [[ $branch_ == $upstream_ ]] && return 1
    show_run_command git rebase $upstream_ $branch_
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
    git_stash_and gr "$@"
}

grs () {
    show_run_command git rebase --skip
}

gru () {
    show_run_command git remote get-url origin
}

gsa () {
    git_stash_and "$@"
}

gsg () {
    gs
    glg
}

gsi () {
    local _doc___="""Menu to help clearing git status"""
    gxi gsi_show_diff_ gsi_response_ "$@"
}

gss () {
    local _doc___="""git short status"""
    gs --short "$@"
}

git_stash () {
    local _doc___="""git stash"""
    show_run_command git stash "$@"
}

gso () {
    git_stash_and go "$@"
}

gsp () {
    local _doc___="""Porcelain status"""
    gs --porcelain
}

gta () {
    gt "$@"
}

gtd () {
    show_run_command git tag -d "$@"
}

gtD () {
    gpod "$@"
}

gtl () {
    gt "$@"
}

gtl () {
    gt --list "$@"
}

gvd () {
    local _doc___="""vim diff all changed files"""
    shift_dir "$@" && shift
    for f in $(git_status_line_dir $dir | grep "^ M" | cut -dM -f2)
    do
        git dv $f
    done
    QUESTIONS=$(untracked $dir)
    [[ -n $QUESTIONS ]] && v $QUESTIONS
}

gvi () {
    local _doc___="""Menu to help vimming git status"""
    gxi gvi_show_diff_ gvi_response_ "$@"
}

gxi () {
    local _doc___=""""""
    local show_diff_=$1; shift
    local response_=$1; shift
    local responded_=
    dir=$(show_arg_dir_or_here "$1") && shift
    stashed_=
    GXI_QUERY=
    show_green remote
    glf 1
    glg
    show_this_branch -r
    show_pre_loop_
    while git status --short "$dir"; do
        show_green staged
        git di --staged
        show_green files
        responded_=
        for file_ in $(git_status_line_dir_changes "$dir"); do
            [[ -n "$file_" ]] || continue
            gxi_grep_ $file_ $GXI_QUERY || continue
            $show_diff_ "$file_"
            gxi_request_ "$file_" || break
            $response_ "$file_" && responded_=1
        done
        [[ $answer =~ [qQ] || -z $responded_ ]] && break
        [[ $answer =~ [sS] ]] && gxi_stash_
        gi
        git status -v | g -q "working [a-z][a-z]* clean" && break
        [[ -n $QUESTIONS ]] && v $QUESTIONS
        show_pre_loop_
    done
    [[ -n $stashed_ ]] && git_stash_pop
    git dn --staged
    git status
}

sit () {
    show_run_command git "$@"
}


# xxxx

gbd_ () {
    local current_branch_=$(get_branch)
    if [[ "$@" =~ $current_branch_ ]]; then
        if [[ "$@" == "master" ]]; then
            git checkout $(git tag --list  | sort -V | tail -n1)
            current_branch_=$(get_branch)
            if [[ $current_branch_ == "master" ]]; then
                show_error Please checkout another branch before deleting master
                return 1
            fi
        else
            gom
        fi
    elif [[ "$@" =~ ^-[dD]$ ]]; then
        if [[ $current_branch_ == "master" ]]; then
            show_error Please checkout another branch before deleting master
            return 1
        elif [[ $current_branch_ == "fred" ]]; then
            answer=Y
        else
            read -p "OK to remove $current_branch_ [y]? " -n1 answer
        fi
        [[ -n $answer && ! $answer =~ [yY] ]] && return 1
        if git status 2>&1 | grep -q git.merge...abort; then
            gma
        fi
        gom
        show_run_command git branch "$@" $current_branch_
        return 0
    fi
    show_run_command git branch "$@"
}

gbac () {
    show_run_command git branch --all --contains "$@"
}

gbdd () {
    local branch_=
    for branch_ in $(git branch | grep -v master | sed -e "s:^[* ]*::"); do 
        if mastered $branch_; then
            gbd $branch_
        fi
    done
}

gbdr () {
    gbD
    gr
}

gbDD () {
    local current_branch_=$(get_branch)
    [[ "$@" ]] && current_branch_="$@"
    gbD "$@" && gpod $current_branch_
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

gcuw () {
    local_gcu 'Alan Brogan' $(work_email ab13173)
}

gdis () {
    gdi --staged "$@"
}

gipf () {
    gi "$@"
    gpf
}

glggggggg () {
    tput smcup
    show_command git lg "$@"
    git lg "$@"
    tput rmcup
}

glgo () {
    glg origin/"$@"
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
    g -q $1 $2 && gai $2 || echo fuck off >&2
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

gpff () {
    gp --force "$@"
}

gppp () {
    gpf "$@" && gpt
}

gpsu () {
    show_run_command git push --set-upstream origin "$@"
}

grmt () {
    local current_branch_=$(get_branch)
    show_run_command git rebase master $current_branch_ -X theirs
}

grup () {
    show_run_command git remote update origin --prune
    git branch | grep -q fred && gbD fred
    show_run_command git fetch --tags --force --prune-tags --prune origin "refs/tags/*:refs/tags/*"
    show_run_command git gc --prune=now --aggressive 2>&1 | grep -v -e objects -e ' reused '
    show_run_command git repack -a -d 2>&1
}

gsri () {
    git_stash_and gri "$@"
}

git_status_line_dir () {
    local dir_="$1"; shift
    status_line_ -C $dir_ "$@"
}
alias gssd=git_status_line_dir

git_stash_branch () {
    local branch_=$1
    [[ $branch_ ]] || branch_=fred && shift
    [[ $branch_ == 'fred' ]] && QUietly git branch -D fred
    show_run_command git stash branch $branch_ "$@"
}
alias gstb=git_stash_branch

git_stash_list () {
    show_run_command git stash list
}
alias gstl=git_stash_list

git_stash_pop () {
    show_run_command git stash pop
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
    gtl | g "$@"
}

gurl () {
    grep https .git/config | sed -e "s:url =::" | g git.*
}

gvsd () {
    shift_dir "$@" && shift
    for file_ in $(git_status_line_dir $dir); do
        gvi_vim_ "$file_"
    done
}

# xxxxx

clone () {
    local range_=
    [[ "$1" == "-r" ]] && range_=ranger
    local remote_=
    [[ -n $1 ]] && remote_=$1 && shift
    local local_=
    [[ -n $1 ]] && local_=$1 && shift

    local clone_log_=/tmp/clone_.log
    echo "" > $clone_log_
    show_run_command git clone $remote_ $local_ > $clone_log_ 2>&1
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

# xxxxxx
# xxxxxxx
# xxxxxxxx

git_kd_ () {
    cde "$@" > ~/bash/fd/1 2> ~/bash/fd/2
}

mastered () {
    has_branch master "$1" master || has_branch master origin/$1 
}

get_root () {
    git_root -q "$@" 2>/dev/null
}

git_root () {
    local stdout_=$(verbosity "$@")
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
    local full_dir_=$(readlink -f $git_dir_)
    if ! git -C "$full_dir_" rev-parse --git-dir > /tmp/fd1 2>/tmp/fd2; then
        cat /tmp/fd1
        cat /tmp/fd2 >&2
        return 1
    fi
    $show_ git -C "$full_dir_" rev-parse --show-toplevel
}

# xxxxxxxxx

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
    if git_changed; then
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

gxi_menu_ () {
    GSI_MENU=
    suffix=", "
    red_one "/"
    red_one q uit
    red_one a dd
    stat_modified $1 && red_two in t eractive
    red_two a m end
    red_two am e dit
    red_two sta g ed
    red_one s tash
    stat_modified $1 && red_one d iff
    red_two d r op
    red_two de l ete
    [[ -n $GIT_ADDED ]] && red_one f asten
    red_two comm i t
    red_one v im
    stat_modified $1 && red_one p atch
    suffix=";"
    red_one space " next"
    echo -n -e "$(status_chars_ $1) $1: $GSI_MENU"
}

get_branch () {
    git rev-parse --abbrev-ref HEAD 2> /dev/null || return 1
}

git_branch () {
    local show_=show_run_command
    [[ $1 == -q ]] && show_=
    $show_ git rev-parse --abbrev-ref HEAD
}

sed_origin () {
    git remote set-url origin $(git remote get-url origin | sed "$@")
}

# xxxxxxxxxxx

clean_clone() {
    show_run_command git reset head .
    show_run_command git checkout .
    show_run_command git clean -f -d -f
    show_run_command git fetch --all
    show_run_command git checkout master
    for branch in $(git branch | grep -v -e master -e deployed-to); do
        [[ -f $branch ]] && continue
        show_run_command git branch -d $branch
    done
}

git_changed () {
    local git_dir=$(git_root "$1")
    [[ -n $git_dir ]] || return 1
    git -C $git_dir status --porcelain | grep -q "$git_status_regexp_"
}

# xxxxxxxxxxxx

gxi_request_ () {
    gxi_menu_ $1
    read -e -n1 -p " " answer
    [[ $answer =~ [qQ] ]] && return 1
    return 0
}

git_status_line_dir_changes () {
    local dir_="$1"; shift
    git_status_line_dir "$dir_" | grep "^\([MDU ][MAU]\|??\)" | sed -e "s/^...//"
}

https_origin () {
    sed_origin -e s,http:,https:,
}

# xxxxxxxxxxxxx

trim_git_lines () {
    call_me_alan_ -e "s/ ago//"
}

git_log_lines_to_screen () {
    local number_of_commits_=7
    local number_of_commits_=15
    if [[ $1 =~ ^-?[0-9]+$ ]]; then
        number_of_commits_=$1
        shift
        if [[ $1 =~ ^-?[0-9]+$ ]]; then
            number_of_commits_=$1
            shift
        fi
    fi
    # set +x
    local log_cmd_=lg
    show_run_command git status --short
    show_command git $log_cmd_ -n $number_of_commits_ "$@"
    # set -x
    git_log_to_screen $log_cmd_ -n $number_of_commits_ "$@" | trim_git_lines
    # set +x
}

git_log_to_screen () {
    local log_cmd_=$1; shift
    local number_of_lines_=
    if [[ $1 =~ ^-[ln] ]]; then
        shift
        if [[ $1 =~ ^-?[0-9]+$ ]]; then
            number_of_lines_=$1
            shift
        fi
    fi
    local vertical_lines_=${LINES:-$(screen_height)}
    local one_third_of_vertical_=$(( $vertical_lines_ / 3 ))
    local lines_=${number_of_lines_:-$one_third_of_vertical_}
    git $log_cmd_ --color "$@" | head -n $lines_
}

untracked () {
    local path_="$1"; shift
    ( test -d "$path_" && git_status_line_dir "$path_" || status_line_ "$path_" ) | grep "??" | cut -d' ' -f2
}

do_git_status_ () {
    local _doc___="get the status from git"
    local root_=$(git_root "$1")
    if [[ $root_ ]]; then
        shift
        git -C $root_ status "$@"
    else
        show_error "Fail: git_root $@"
        return 1
    fi
}

# xxxxxxxxxxxxxx

in_repo () {
    git rev-parse --is-inside-work-tree
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
    [[ -d "${dir}/.git" ]] || return 1
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
    [[ -d $git_dir_ ]] && git_status_line_dir "$git_dir_" 2> ~/bash/fd/2 | grep "$git_status_regexp_"
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

gdis_ () {
    local _doc___="""git di args; git short status"""
    if stat_untracked "$1"; then
        kat -n "$1"
        return 0
    fi
    if stat_modified "$1"; then
        local lines_=$(wc -l "$1" | cut -d ' ' -f1)
        if [[ $lines_ < $LINES ]]; then
            git di "$1"
        else
            gdi "$1"
        fi
    fi
    git status --short $1
}

gsi_show_diff_ () {
    if stat_untracked "$1"; then
        if [[ -d "$1" ]]; then
            find "$1" -type f -print
        elif [[ -f "$1" ]]; then
            kat -n "$1"
        else
            echo "Cannot handle $1"
        fi
        return 0
    fi
    if stat_modified "$1"; then
        local lines_=$(wc -l "$1" | cut -d ' ' -f1)
        if [[ $lines_ < $LINES ]]; then
            git di "$1"
        else
            gdi "$1"
        fi
    fi
    git status --short $1
}

gvi_show_diff_ () {
    git diff "$1"
    git status --short $1
}

ggi_response_ () {
    [[ $answer =~ [rR] ]] && gsi_drop_ "$1" && return 0
    [[ $answer =~ [lL] && -f $1 ]] && rm -f "$1" && return 0
    [[ $answer =~ [vV] ]] && gsi_vim_ "$1" && return 0
    gxi_response_ "$@"
}

gsi_response_ () {
    [[ $answer =~ [yY] ]] && ga "$1" && return 0
    ggi_response_ "$@"
}

gvi_response_ () {
    [[ $answer =~ [yY] ]] && ga "$1" && return 0
    ggi_response_ "$@"
}

gxi_response_ () {
    if [[ $answer =~ [iIgGdDpPtT] ]]; then
        [[ $answer =~ [iI] ]] && gi
        [[ $answer =~ [gG] ]] && git diff --staged
        if stat_modified "$1" ; then
            [[ $answer =~ [dD] ]] && git di "$1"
            [[ $answer =~ [pP] ]] && git diff --patch "$1"
            [[ $answer =~ [tT] ]] && gai "$1"
        fi
        gxi_request_ "$1"
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

status_line_ () {
    [[ -n "$*" ]] && git status --short . || git status --short "$@"
}

status_chars_ () {
    git -C $dir status -s -- $1 | sed -e "s/\(..\).*/\1/"
}

gxi_stash_ () {
    if [[ -z $stashed_ ]]; then
        stashed_=gxi
        git stash
    fi
}

gxi_grep_ () {
    local file_=$1; shift
    [[ -z "$@" ]] && return 0
    grep -q "$@" $file_
}

gsi_drop_ () {
    if [[ $answer =~ [rR] ]]; then
        stat_modified "$1" && go "$1"
        stat_untracked "$1" && rm -i "$1"
    fi
}

gvi_drop_ () {
    if [[ $answer =~ [rR] ]]; then
        stat_modified "$1" && go "$1"
        stat_untracked "$1" && rm -f "$1"
    fi
}

gvi_git_dv_ () {
    local one_="$1"
    shift
    gvi_other_vim_
    if stat_modified "$1"; then
        git dv $(echo "$1" | cut -dM -f2)
    else
        gvi_vim_ "$1"
    fi
}

gvi_vim_ () {
    if stat_untracked "$1"; then
        v $(status_line_ "$1" | grep "??" | cut -d' ' -f2)
    elif stat_modified "$1"; then
        v $(echo "$1" | cut -dM -f2)
    elif stat_added "$1"; then
        v  $(echo "$1" | cut -dA -f2)
    fi
    status_line_ "$1"
}

gsi_vim_ () {
    stat_modified "$1" && git dv "$1" || git diff "$1" | vin
}


