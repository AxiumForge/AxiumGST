#!/usr/bin/env bash
set -euo pipefail

# Removes the oversized kerbl_2023 PDF from git history and force-pushes.
# Safe to re-run; uses filter-repo if available, falls back to filter-branch.
#
# Usage: ./bin/remove_large_pdf.sh [remote] [branch]
# Defaults: remote=origin, branch=main

REMOTE="${1:-origin}"
BRANCH="${2:-main}"
PDF_PATH="docs/refs/kerbl_2023_3d_gaussian_splatting.pdf"

require_clean_index() {
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Error: You have unstaged or staged changes. Commit/stash before running." >&2
    exit 1
  fi
}

check_pdf_blob() {
  git rev-list --objects --all | grep -F "$PDF_PATH" || true
}

require_clean_index

echo "Checking for PDF blob in history..."
if ! check_pdf_blob; then
  echo "No $PDF_PATH found in history; nothing to do."
  exit 0
fi

if command -v git-filter-repo >/dev/null 2>&1; then
  echo "Using git filter-repo to remove $PDF_PATH ..."
  git filter-repo --path "$PDF_PATH" --invert-paths
else
  echo "git filter-repo not found; using git filter-branch (slower)..."
  FILTER_BRANCH_SQUELCH_WARNING=1 \
  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch '$PDF_PATH'" \
    --prune-empty --tag-name-filter cat -- --all
fi

echo "Verifying removal..."
if check_pdf_blob; then
  echo "Error: PDF still present after rewrite; aborting." >&2
  exit 1
fi

echo "Force-pushing rewritten history to $REMOTE $BRANCH ..."
git push --force-with-lease "$REMOTE" "$BRANCH"

echo "Done. PDF removed from history and branch pushed."
