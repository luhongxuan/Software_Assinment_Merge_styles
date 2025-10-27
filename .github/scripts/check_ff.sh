#!/bin/bash
# Prevent non-fast-forward merges on main

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" == "main" ]; then
  if ! git merge-base --is-ancestor origin/main HEAD; then
    echo "❌ Non-fast-forward merge detected. Please rebase or use PR."
    exit 1
  fi
fi
echo "✅ Branch is up to date with main. Proceeding..."
