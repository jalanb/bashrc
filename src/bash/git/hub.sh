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
