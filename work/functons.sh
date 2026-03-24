#! /bin/bash


work () {
    echo "$@"."${WORK_COM}"
}

homework () {
    echo "${HOME}/${WORK}"
}

work_email () {
    echo "$@"@"${WORK_COM}"
}

is_work_server () {
    [[ "$1" =~ ${WORK_COM} ]]
}

work_github () {
    echo "https://github.com/SMBCGitHub"
}

ack () {
    if [[ -x /usr/local/lib64/perl5 ]]; then
        $HOME/.local/bin/ack "$@"
    else
        $HOME/.local/bin/rg "$@"
    fi
}

alin () {
    if [[ -d .github ]]; then
        quietly ansible-lint --exclude=.github "$@"
    else
        quietly ansible-lint "$@"
    fi
}

cdg () {
    local base=~/github/SMBCGitHub
    cd $base || return 1
    [[ $1 ]] || return 0

    shopt -s nullglob
    local -a matches=( *"$1"* )
    shopt -u nullglob
    local choice
    case ${#matches[@]} in
        0) echo "No matched sub-dirs: $PWD/*$1*" >&2
            return 2
            ;;
        1)  cd "${matches[0]}"
            pwd
            return 0
            ;;
        *) echo "Matching sub-dirs:"
            choice=$(
                ls -d "$base"/*"$1"* \
                | while IFS= read -r p; do [[ -d $p ]] && printf '%s\n' "${p##$base/}"; done \
                | fzf --prompt="cdg> " --height=40% --reverse
            ) || return 3
            cd "$base/$choice" || return 4
            return 0
            ;;
    esac
}

cdj () {
    cd ~/github/jalanb/"$@"
}

anav () {
    ansible-navigator "$@"
}

arun () {
    anav run "$@"
}
