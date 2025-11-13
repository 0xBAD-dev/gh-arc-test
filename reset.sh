#!/usr/bin/env bash

set -e

git checkout .

# reset date to avoid prompts from tests in auth-branching flow
git checkout reset
git commit --amend --no-edit --reset-author
git push origin reset --force-with-lease

# reset main
git checkout main
git reset --hard origin/reset
git push origin main --force-with-lease
git remote prune origin

# Array of branches to keep
KEEP_BRANCHES=("main" "reset")

# Fetch the latest remote branches
git fetch --all

# Delete local branches that are not in the KEEP_BRANCHES array
for branch in $(git branch --list | sed 's/^[ *]*//'); do
  if [[ ! " ${KEEP_BRANCHES[*]} " =~ ${branch} ]]; then
    echo "Deleting local branch: $branch"
    git branch -D "$branch"
  fi
done

# Delete remote branches that are not in KEEP_BRANCHES
for branch in $(git branch -r --format='%(refname:short)' | sed 's|^origin/||' | grep -Ev '^(HEAD|origin)$'); do
  if [[ ! " ${KEEP_BRANCHES[*]} " =~ ${branch} ]]; then
    echo "Deleting remote branch: $branch"
    git push origin --delete "$branch"
  fi
done

echo "Branch cleanup complete."
