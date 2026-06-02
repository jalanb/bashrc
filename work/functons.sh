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

cdd () {
    cd ~/down
    l
}

cdb () {
    local base=~/bitbucket/smbc
    cd $base || return 1
    [[ $1 ]] || return 0
    shopt -s nullglob
    shopt -s nocaseglob
    local -a matches=( *"$1"* )
    shopt -u nocaseglob
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

cdg () {
    cdx ~/github/SMBCGitHub "$@"
}

cdj () {
    cdx ~/github/jalanb "$@"
}

cdw () {
    cdx ~/workspaces "$@"
}

cdx () {
    local base="$1"
    cd $base || return 1
    shift
    if [[ ! $1 ]]; then
        l
        return 0
    fi
    shopt -s nullglob
    shopt -s nocaseglob
    local -a matches=( *"$1"*/ )
    # declare -p matches
    shopt -u nocaseglob
    shopt -u nullglob
    local choice
    case ${#matches[@]} in
        0) echo "No matched sub-dirs: $PWD/*$1*" >&2
            return 2
            ;;
        1)  cd "${matches[0]}"
            pwdl
            return 0
            ;;
        *) echo "Matching sub-dirs:"
            choice=$(
                ls -d "$base"/*"$1"* \
                | while IFS= read -r p; do [[ -d $p ]] && printf '%s\n' "${p##$base/}"; done \
                | fzf --prompt="cdg> " --height=40% --reverse
            ) || return 3
            cd "$base/$choice" || return 4
            pwdl
            return 0
            ;;
    esac
}

fzf () {
    if test -x ~/.local/bin/fzf; then
        ~/.local/bin/fzf "$@"
        return 0
    else
        echo "$@"
        return 1
    fi
}

pwdl () {
    echo
    lgreen $PWD
    echo
    echo
    if [ -z "$(ls -A .)" ]; then
        ls -ld $PWD
    else
        l
    fi
    echo
}

alint () {
    if [[ -d .github ]]; then
        quietly ansible-lint --exclude=.github "$@"
    elif [[ $@ ]]; then
        quietly ansible-lint "$@"
    else
        quietly ansible-lint .
    fi
}

COLLECTIONS=/u/abrogan/github/SMBCGitHub/SMBC-JRIA-Ansible_Github_as_Code/collections
anav () {
    addcoll
    ansible-navigator "$@"
    remcoll
}

anavi () {
    anav --mode interactive "$@"
    clear
}

arun () {
    anavi run "$@"
}

adeb () {
    arun -v "$@"
}

aclean () {
    local playbook_= arg_=
    for arg_ in "$@"; do
        if test -f $arg_; then
            playbook_="$arg_"
        fi
    done
    if [[ ! $playbook_ ]]; then
        show_fail "No playbook found: ""$@"
        return 1
    fi
    set -x
    local log="${playbook_%yml}log"
    env > "$log"
    echo >> "$log"
    TERM=dumb ANSIBLE_FORCE_COLOR=0 NO_COLOR=1 \
        anav run --mode stdout -vvvv "$@" | ~/.local/bin/clean_navigator >> "$log"
    set +x
    echo "bat \"$log\""
}

GACWORK=/u/abrogam/workspaced/gac

addcoll () {
    export ANSIBLE_COLLECTIONS_PATH=collections/
}

collinstall () {
    ansible-galaxy install -r collections/requirements.yml -c
#   ansible-galaxy install -r collections/requirements.yml --force -c
}

remcoll () {
    unset ANSIBLE_COLLECTIONS_PATH
}

collect () {
    local collections_=/u/abrogan/github/SMBCGitHub/SMBC-JRIA-Ansible_Github_as_Code/collections
    case $1 in
        add) addcoll
            ;;
        rem|remove)
            remcoll
            ;;
        in|install)
            ansible-galaxy install -r $COLLECTIONS/requirements.yml --force -c
            ;;
    esac
}

deduplicate_repo_url () {
    local owner_repo=$1
    local branch=$2
    local owner=${owner_repo%%/*}
    local repo=${owner_repo#*/}
    if [[ $repo == SMBC-JRIA-* ]]; then
        owner=SMBC
        repo=${repo#SMBC-JRIA-}
    fi
    normalise () { tr '[:upper:]_- ' '[:lower:]' | tr -d '-_ '; }
    local nrepo=$(printf '%s' "$repo" | normalise)
    local nbranch=$(printf '%s' "$branch" | normalise)
    if [[ $nbranch == *$nrepo* ]]; then
        branch=${branch//${branch%%-*}-/}
    fi
    printf '%s/%s:%s' "$owner" "$repo" "$branch"
}

test_netwrix_install () {
    # Remember that "install" is the default action for linux_agents_netwrix
    test_netwrix linux_agents_netwrix "$@"
}

test_netwrix_uninstall () {
    test_netwrix linux_agents_netwrix_uninstall "$@"
}

#       --ask-vault-pass \
#        -e @/home/runner/.ansible/vault_become \
#        -e snow_company=SMBC \
#       /u/abrogan/github/SMBCGitHub/SMBC-JRIA-Netwrix_Collection/playbooks/deploy_netwrix.yml \

test_netwrix () {
    local tag_="$1"; shift || true
    [[ $tag_ ]] || return 3
    addcoll
    cd ~/workspaces/netwrix; pwd
    set -x
    ansible-navigator run \
        test_netwrix_agent.yml \
        --inventory ~/github/SMBCGitHub/SMBC-JRIA-Ansible_Linux_Inventory/DEV \
        -bkK \
        -- \
        --limit pagmgtdv02.smbcgroup.com \
        --tags "$tag_" \
        "$@"
    set +x
}
