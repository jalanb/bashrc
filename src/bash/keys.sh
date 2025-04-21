#! /bin/cat
KEYBOARD=~/$(dirname $BASH_SOURCE)/keyboard

keys_git () {
    local __doc__="""Run git in the keyboard directory."""
    git -C $(keyboard_path) "$@"
}

main_to_keyboard () {
    keys_git log keyboard --merges --grep="Merge branch '__main__'" -1 --pretty=format:"%H"
}

commit_key_file () {
    local __doc__="""Commit a single file to the keyboard branch with its filename as the commit message."""

    local file_=$1
    local letter_=$(basename "$file_" .sh)

    # Check if a commit with the same message (letter) exists after the last merge from __main__
    local existing_commit_=$(keys_git log keyboard --pretty=format:"%H" --grep="^$letter_$" --since="$(main_to_keyboard)")

    if [ -n "$existing_commit_" ]; then
        # Amend the existing commit if found
        keys_git commit --amend --no-edit --only "$file_"
    else
        # Create a new commit with the filename letter as the message
        keys_git commit -m "$letter_" --only "$file_"
    fi
}

push_keys () {
    local __doc__="""Stash changes, commit modified keyboard scripts, and push the keyboard branch to remote."""

    (cd $(keyboard_path)

        # Stash any existing changes on the current branch
        git stash --include-untracked

        # Ensure the keyboard branch exists, and if not, create it from __main__
        if ! git rev-parse --verify keyboard >/dev/null 2>&1; then
            git checkout __main__
            git checkout -b keyboard
        else
            git checkout keyboard
        fi

        # Process each modified file individually
        for file_ in $(git ls-files -m); do
            commit_key_file  "$file_"
        done

        # Push the keyboard branch to the remote repository
        git push origin keyboard

        # Return to the previous branch and apply the stashed changes
        git checkout -
        git stash pop 2>/dev/null
    )
}

KEYS_HASH="fred"

push_changed_keys () {
    local __doc__="""Check if ~/bash/keyboard/*.sh has changed, call keys_read, and commit changes if needed."""
    local new_hash_=$(md5sum ~/bash/keyboard/*.sh | md5sum)

    if [ "$new_hash_" != "$KEYS_HASH" ]; then
        KEYS_HASH=$new_hash_
        export KEYS_HASH
        keys_read
        push_keys
    fi
}


KEYBOARD="$(dirname $(readlink -f $BASH_SOURCE))/keyboard"

keyboard_path () {
    echo ~/bash/keyboard/$1
}

key_exists () {
    local script_=
    for script_ in $(keyboard_path $1); do
        quietly test -f "$script_" && return 0
    done
    return 5
}

path_to_key () {
    local script_="${1%.sh}.sh"
    echo $(keyboard_path $script_)
}

ls_path_to_key () {
    quietly ls $(path_to_key $1)
}

echo_key () {
    [[ $1 ]] || return 4
    local script_=$(path_to_key $1)
    echo $script_
}

echo_keys () {
    [[ $@ ]] || return 0
    (
        command cd $(keyboard_path " ")
        for arg_ in $(quietly ls "$@"); do
            [[ $arg_ =~ __init__ ]] && continue
            [[ $arg_ ]] || continue
            ls $arg_
        done
    )
}

key_scripts () {
    (
        command cd $(keyboard_path)
        readlink -f $(echo_keys [a-z12].sh)
    )
}

key_init () {
    path_to_key __init__
}

same_path () {
    [[ $2 ]] || return 4
    [[ $1 ]] || return 8
    [[ $(readlink -f "$1") == $(readlink -f "$2") ]]
}

keys_merge () {
    local __doc__="""Create a pull request from keyboard to __main__, capture the PR number, merge it, and delete the keyboard branch."""

    (cd $(keyboard_path)

        # Ensure we're up to date with the remote
        git fetch origin

        # Create a pull request from keyboard to __main__ and capture the PR number
        local pr_number=$(gh pr create \
            --base __main__ \
            --head keyboard \
            --title "Merge keyboard into __main__" \
            --body "Automated merge of keyboard changes into __main__" \
            --json number \
            --jq '.number')

        # Set the version number or use the PR number as needed
        echo "PR number is: $pr_number"
        # You can now use $pr_number to set your version number or perform other actions

        # Merge the pull request using admin privileges (bypassing review if needed)
        gh pr merge $pr_number --admin --delete-branch --squash

        # Optionally delete the local keyboard branch after the merge
        git branch -d keyboard
    )
}

keys_write () {
    local init_=$(key_init)
    echo "#! /usr/bin/env bat -l bash" > $init_
    for script_ in $(key_scripts); do
        grep -v "^#! " $script_ >> $init_
    done
}

keys_read () {
    keys_write
    . $(key_init)
}

keys_vim () {
    local init_=$(key_init) files_=
    if [[ ! "$@" ]]; then
        files_="$(key_scripts)"
        vv $files_
        return
    fi
    local option_= path_= file_=
    dir_=$(keyboard_path)
    for option_ in "$@"; do
        path_=$dir_/$option_
        [[ -f ${path_} ]] && file_=${path_}
        [[ -f ${path_}.sh ]] && file_=${path_}.sh
        [[ -f $file_ ]] && files_="$files_ $file_"
        file_=
    done
    [[ $files_ ]] || return 6
    vim -p $files_
    keys_read
}

keys_read
