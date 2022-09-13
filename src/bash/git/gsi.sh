ggi () {
    local _doc___="""Me neither"""
    gxi ggi_show_diff_ ggi_response_ "$@"
}

gsi () {
    local __doc__="""Menu to help clearing git status"""
    gxi gsi_show_diff_ gsi_response_ "$1"
}

gvi () {
    local __doc__="""Menu to help vimming git status"""
    gxi gvi_show_diff_ gvi_response_ "$1"
}

ggi () {
    local __doc__="""Menu to help git handle files"""
    gxi ggi_show_diff_ ggi_response_ "$1"
}

gxi () {
    local __doc__="""Show a git related menu"""
    local show_diff_=$1; shift
    local response_=$1; shift
    local responded_=
    GXI_DIR=$(python_realpath "$1") && shift
    [[ $GXI_DIR ]] || GXI_DIR=$(python_realpath .)
    STASHED_=
    GXI_QUERY=
    LESS=MRFX g lll
    LESS=MRFX g lf -n1
    show_pre_loop_
    while gxitss; do
        show_green staged
        gxit di --staged
        echo
        responded_=
        for file_ in $(git_status_line_dir_changes); do
            [[ -n "$file_" ]] || continue
            echo "$file_"
            echo gxi_grep_ $file_ $GXI_QUERY
            gxi_grep_ $file_ $GXI_QUERY || continue
            $show_diff_ "$file_"
            gxi_request_ "$file_" || break
            $response_ "$file_" && responded_=1
        done
        [[ $answer =~ [qQ] || -z $responded_ ]] && break
        [[ $answer =~ [sS] ]] && gxi_stash_
        gi
        gxit status -v | grep -q "working [a-z][a-z]* clean" && break
        [[ -n $QUESTIONS ]] && v $QUESTIONS
        show_pre_loop_
    done
    [[ -n $STASHED_ ]] && gxit stash pop
    gxit dn --staged
    gxit status
}

gxit () {
    local dir_=.
    [[ -d "$GXI_DIR" ]] && dir_="$GXI_DIR"
    git -C "$dir_" "$@"
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
        gxit d "$1"
    fi
    gxit status --short $1
}

ggi_show_diff_ () {
    local __doc__="""git di args; git short status"""
    if stat_untracked "$1"; then
        kat -n "$1"
        return 0
    fi
    if stat_modified "$1"; then
        local lines_=$(wc -l "$1" | cut -d ' ' -f1)
        if [[ $lines_ < $LINES ]]; then
            gxit d "$1"
        else
            gdi "$1"
        fi
    fi
    gxit status --short $1
}

gvi_show_diff_ () {
    gxit diff "$1"
    gxit status --short $1
}

ggi_response_ () {
    local path_="$1"; shift
    [[ $answer =~ [rR] ]] && gsi_restore_ "$path_" && return 0
    [[ $answer =~ [lL] ]] && rm -f "$path_" 2>/dev/null && return 0
    [[ $answer =~ [vV] ]] && gsi_vim_ "$path_" && return 0
    gxi_response_ "$path_"
}

gsi_response_ () {
    local path_="$1"; shift
    [[ $answer =~ [yY] ]] && ga "$path_" && return 0
    ggi_response_ "$path_"
}

gxi_response_ () {
    local path_="$1"; shift
    if [[ $answer =~ [iIgGdDpPtT] ]]; then
        [[ $answer =~ [iI] ]] && gi
        [[ $answer =~ [gG] ]] && gxit diff --staged
        if stat_modified "$path_" ; then
            [[ $answer =~ [dD] ]] && gxit di "$path_"
            [[ $answer =~ [pP] ]] && gxit diff --patch "$path_"
            [[ $answer =~ [tT] ]] && gai "$path_"
        fi
        gxi_request_ "$path_"
        return 0
    fi
    [[ $answer =~ [aA] ]] && ga "$path_" && return 0
    [[ $answer =~ [mM] ]] && git commit --amend "$path_" && return 0
    [[ $answer =~ [eE] ]] && git commit --amend --edit "$path_" && return 0
    if [[ $answer == "/" ]]; then
        read -p "/ " GXI_QUERY
        return 0
    fi
    return 1
}

gvi_response_ () {
    local path_="$1"; shift
    [[ $answer =~ [yY] ]] && ga "$path_" && return 0
    ggi_response_ "$path_"
}

gxi_menu_ () {
    local path_="$1"; shift
    GSI_MENU=
    suffix=", "
    red_one "/"
    red_one q uit
    red_one a dd
    stat_modified "$path_" && red_two in t eractive
    red_two a m end
    red_two am e gid
    red_two sta g ed
    red_one s tash
    stat_modified "$path_" && red_one d iff
    red_one r estore
    red_two de l ete
    [[ -n $GIT_ADDED ]] && red_one f asten
    red_two comm i t
    red_one v im
    stat_modified "$path_" && red_one p atch
    suffix=";"
    red_one space " next"
    echo -n -e "$(status_chars_ "$path_") $path_: $GSI_MENU"
}

status_chars_ () {
    [[ -f "$1" ]] || return 1
    gxitss -- "$1" | sed -e "s/\(..\).*/\1/"
}

gxitss () {
    gxit status --short "$@"
}

show_pre_loop_ () {
    show_green_line status
}

git_status_line_dir_changes () {
    gxitss | grep "^\([MDU ][MAU]\|??\)" | sed -e "s/^...//"
}

gxi_grep_ () {
    local file_=$1; shift
    [[ -z "$@" ]] && return 0
    grep -q "$@" $file_
}

gsi_restore_ () {
    if [[ $answer =~ [rR] ]]; then
        stat_modified "$1" && git restore "$1"
        stat_untracked "$1" && rm -i "$1"
    fi
}

gvi_drop_ () {
    if [[ $answer =~ [rR] ]]; then
        stat_modified "$1" && go "$1"
        stat_untracked "$1" && rm -f "$1"
    fi
}

dstatus_chars_ () {
    git -C $dir status -s -- $1 | sed -e "s/\(..\).*/\1/"
}

gvi_git_dv_ () {
    local one_="$1"
    shift
    gvi_other_vim_
    if stat_modified "$1"; then
        gxit dv $(echo "$1" | cut -dM -f2)
    else
        gvi_vim_ "$1"
    fi
}

gsi_vim_ () {
    stat_modified "$1" && gxit dv "$1" || gxit diff "$1" | vin
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

gxi_request_ () {
    local path_="$1"; shift
    gxi_menu_ "$path_"
    read -e -n1 -p " " answer
    [[ $answer =~ [qQ] ]] && return 1
    return 0
}

gxi_stash_ () {
    if [[ -z $STASHED_ ]]; then
        STASHED_=gxi
        gxit stash
    fi
}

gvi_vim_ () {
    if stat_untracked "$1"; then
        vim $(gxitss -- "$1" | grep "??" | cut -d' ' -f2)
    elif stat_modified "$1"; then
        vim $(echo "$1" | cut -dM -f2)
    elif stat_added "$1"; then
        vim  $(echo "$1" | cut -dA -f2)
    fi
    gxitss -- "$1"
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

python_realpath () {
    [[ $1 ]] || return 1
    python -c"import os; print(os.path.realpath('""$1""'))"
}

