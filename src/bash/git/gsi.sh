
gsi () {
    local _doc___="""Menu to help clearing git status"""
    gxi gsi_show_diff_ gsi_response_ "$@"
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
    show_branch
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
    [[ -n $stashed_ ]] && git stash pop
    git dn --staged
    git status
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

gsi_response_ () {
    [[ $answer =~ [yY] ]] && ga "$1" && return 0
    ggi_response_ "$@"
}

gvi_show_diff_ () {
    git diff "$1"
    git status --short $1
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

show_pre_loop_ () {
    show_green local
    show_branch
    show_green status
}

git_status_line_dir_changes () {
    local dir_="$1"; shift
    git_status_line_dir "$dir_" | grep "^\([MDU ][MAU]\|??\)" | sed -e "s/^...//"
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

status_line_ () {
    [[ -n "$*" ]] && git status --short . || git status --short "$@"
}

status_chars_ () {
    git -C $dir status -s -- $1 | sed -e "s/\(..\).*/\1/"
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

gsi_vim_ () {
    stat_modified "$1" && git dv "$1" || git diff "$1" | vin
}


gxi_request_ () {
    gxi_menu_ $1
    read -e -n1 -p " " answer
    [[ $answer =~ [qQ] ]] && return 1
    return 0
}

gxi_stash_ () {
    if [[ -z $stashed_ ]]; then
        stashed_=gxi
        git stash
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

