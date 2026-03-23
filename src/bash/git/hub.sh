#! /usr/bin/env cat

find_prs() {
  local search_term="$1"

  echo "Searching for PRs matching '$search_term'..."
  gh pr list --search "$search_term" --json number,title,headRefName --jq '.[] | {number, title, branch: .headRefName}'
}


close_prs() {
  local search_term="$1"

  # Get all PR numbers matching the search term
  gh pr list --search "$search_term" --json number --jq '.[].number' | while read -r pr; do
    echo "Closing PR #$pr..."
    gh pr close "$pr"
  done
}

delete_branches() {
  local search_term="$1"

  # Get all matching remote branches
  git branch -r | grep "$search_term" | sed 's/origin\///' | while read -r branch; do
    echo "Deleting remote branch $branch..."
    git push origin --delete "$branch"
  done
}

cleanup_dependabot() {
  local search_term="${1:-dependa}"  # Default to "dependa" if no argument is given
  close_prs "$search_term"
  delete_branches "$search_term"
}

create_pr () {
    local __doc__="""Create a PR on GitHub for current branch"""
    local main_="$(main_branch)"
    if ! ahead_of_branch $main_; then
        echo "No commits ahead of $main_" >&2
        return 1
    fi
    local branch_=$(git rev-parse --abbrev-ref HEAD)
    local title_="${1:-$branch_}"
    local pr_url_=$(gh pr create \
        --base "$main_" \
        --head "$branch_" \
        --title "$title_") || return 1
    local pr_number_=$(basename "$pr_url_")
    gh pr view "$pr_number_" >&2
    echo "$pr_number_"
}

merge_pr () {
    local __doc__="""Merge the PR numbered as $1"""
    local pr_number_="$1"
    gh pr merge "$pr_number_" --merge --delete-branch || return 1
    git fetch --all
}


merge_to_main() {
    if branch_is_on_main; then
        echo "Already on $(main_branch)" >&2
        return 1
    fi
    if git_changes_here; then
        echo "Uncommitted changes — commit or stash first" >&2
        return 1
    fi
    local branch_=$(get_branch)
    gp || return 1
    local pr_number_=$(create_pr) || return 1
    merge_pr "$pr_number_" || return 1
    gomr || return 1
    local bump_cfg_="$(get_root)/.bumpversion.cfg"
    if [[ -f "$bump_cfg_" ]]; then
        local current_=$(bump get)
        bump patch --new-version "${current_%.*}.$pr_number_"
        bump show
    else
        echo "No .bumpversion.cfg — skipping version bump" >&2
    fi
    git branch -D "$branch_"
}
