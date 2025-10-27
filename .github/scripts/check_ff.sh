#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${BASE_REF:-}"
HEAD_SHA="${GITHUB_SHA:-}"

echo "[check_pr_linear] base=$BASE_REF head=$HEAD_SHA"

# 取得 base 與 PR head
git fetch --no-tags origin "$BASE_REF"
git fetch --no-tags origin "$HEAD_SHA"

# 1) PR 內是否包含 merge commit（我們要求線性歷史）
if git rev-list --merges --max-count=1 "origin/${BASE_REF}..${HEAD_SHA}" >/dev/null; then
  echo "❌ PR history contains merge commits. Please rebase to keep a linear history."
  exit 1
fi

# 2) 確保 base 是 head 的祖先（PR 可被 FF 合併）
if ! git merge-base --is-ancestor "origin/${BASE_REF}" "${HEAD_SHA}"; then
  echo "❌ PR cannot be fast-forward merged. Please rebase the PR onto the latest ${BASE_REF}."
  exit 1
fi

echo "✔ PR history is linear and fast-forwardable."
