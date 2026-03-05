#!/usr/bin/env bat

# Provides a function to step through a command using "set -x"

step() {
    local __doc__="""Step through debug output of any command with hjkl navigation"""
    local tmpfile_=$(mktemp)
    (set -x; "$@") 2>"$tmpfile_"
    _step "$tmpfile_"
    rm -f "$tmpfile_"
}

_step() {
    local __doc__="""Main stepping loop through captured debug output"""
    local logfile_=$1
    local lines_=()
    mapfile -t lines_ < "$logfile_"
    local total_=${#lines_[@]}
    local current_=0
    local depth_=0
    while [[ $current_ -lt $total_ ]]; do
        clear
        _step_show_context "$current_" "$depth_" "${lines_[@]}"
        local key_
        read -rsn1 key_
        case $key_ in
            j|k) ((current_++)) ;;
            l) _step_in "$current_" "$depth_" "${lines_[@]}" ;;
            h) _step_out "$current_" "$depth_" "${lines_[@]}" ;;
            q) break ;;
        esac
    done
}

_step_show_context() {
    local __doc__="""Display current line and surrounding context"""
    local current_=$1
    local depth_=$2
    shift 2
    local lines_=("$@")
    local start_=$((current_ - 5))
    [[ $start_ -lt 0 ]] && start_=0
    local end_=$((current_ + 10))
    [[ $end_ -gt ${#lines_[@]} ]] && end_=${#lines_[@]}
    for ((i=start_; i<end_; i++)); do
        if [[ $i -eq $current_ ]]; then
            echo ">>> ${lines_[$i]}"
        else
            echo "    ${lines_[$i]}"
        fi
    done
    echo ""
    echo "j/k: step over | l: step in | h: step out | q: quit"
}

_step_in() {
    local __doc__="""Step into a function call"""
    local current_=$1
    local depth_=$2
    shift 2
    local lines_=("$@")
    ((depth_++))
    ((current_++))
}

_step_out() {
    local __doc__="""Step out of current function"""
    local current_=$1
    local depth_=$2
    shift 2
    local lines_=("$@")
    ((depth_--))
    [[ $depth_ -lt 0 ]] && depth_=0
    ((current_++))
}
