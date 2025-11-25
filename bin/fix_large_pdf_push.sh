#!/usr/bin/env bash
set -euo pipefail

# Hardcoded fixer for the oversized kerbl PDF blocking pushes.
# Steps:
# 1) Require clean working tree
# 2) Rewrite history to drop docs/refs/kerbl_2023_3d_gaussian_splatting.pdf
# 3) Force-push origin main

PDF_PATH="docs/refs/kerbl_2023_3d_gaussian_splatting.pdf"

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: Working tree is not clean. Commit or stash changes, then rerun." >&2
  exit 1
fi

echo "Removing $PDF_PATH from all history (git filter-branch)..."
FILTER_BRANCH_SQUELCH_WARNING=1 \
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch '$PDF_PATH'" \
  --prune-empty --tag-name-filter cat -- --all

echo "Verifying removal..."
if git rev-list --objects --all | grep -F "$PDF_PATH" >/dev/null; then
  echo "Error: PDF still found after rewrite. Aborting." >&2
  exit 1
fi

echo "Force-pushing rewritten history to origin main..."
git push --force-with-lease origin main

echo "Done. The large PDF is removed and branch is pushed."
