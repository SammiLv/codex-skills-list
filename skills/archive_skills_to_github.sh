#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/Users/sammilv/Desktop/百度云盘/MacbookPro/AIStudy/Skills列表"
SKILLS_DIR="skills"
INDEX_SCRIPT="$REPO_DIR/skills/generate_local_skills_index.sh"
BRANCH="$(git -C "$REPO_DIR" branch --show-current)"
TIMESTAMP="$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S %Z')"

if [ -x "$INDEX_SCRIPT" ]; then
  "$INDEX_SCRIPT" >/dev/null
fi

git -C "$REPO_DIR" add "$SKILLS_DIR"

if git -C "$REPO_DIR" diff --cached --quiet -- "$SKILLS_DIR"; then
  echo "No changes in $SKILLS_DIR"
  exit 0
fi

git -C "$REPO_DIR" commit -m "Archive skills snapshot ($TIMESTAMP)"
git -C "$REPO_DIR" push origin "$BRANCH"
echo "Archived $SKILLS_DIR to origin/$BRANCH"
