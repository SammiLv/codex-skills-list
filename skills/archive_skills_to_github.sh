#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="/Users/sammilv/.codex/skills"
ARCHIVE_SUBDIR="skills/archived-skills"
REMOTE="origin"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
ARCHIVE_DIR="$REPO_DIR/$ARCHIVE_SUBDIR"
BRANCH="$(git -C "$REPO_DIR" branch --show-current)"
TIMESTAMP="$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S %Z')"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

if [ -z "$BRANCH" ]; then
  echo "Cannot determine the current git branch."
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source skills directory does not exist: $SOURCE_DIR"
  exit 1
fi

echo "Preparing skills archive from $SOURCE_DIR"

cd "$REPO_DIR"

if git remote get-url "$REMOTE" >/dev/null 2>&1; then
  echo "Checking latest code from $REMOTE/$BRANCH"
  git fetch "$REMOTE" "$BRANCH" >/dev/null

  if git rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then
    if ! git merge-base --is-ancestor "$REMOTE/$BRANCH" HEAD; then
      echo "GitHub has commits that are not in the local branch. Please pull or rebase before archiving."
      exit 1
    fi
  fi
fi

while IFS= read -r file_path; do
  rel_path="${file_path#$SOURCE_DIR/}"
  mkdir -p "$TMP_DIR/$(dirname "$rel_path")"
  cp -p "$file_path" "$TMP_DIR/$rel_path"
done < <(find "$SOURCE_DIR" -path "$SOURCE_DIR/.system" -prune -o -type f -name '*.md' ! -name '.DS_Store' -print | sort)

while IFS= read -r skill_dir; do
  while IFS= read -r dir_path; do
    rel_path="${dir_path#$SOURCE_DIR/}"
    mkdir -p "$TMP_DIR/$rel_path"
  done < <(find "$skill_dir" -type d | sort)

  while IFS= read -r file_path; do
    rel_path="${file_path#$SOURCE_DIR/}"
    mkdir -p "$TMP_DIR/$(dirname "$rel_path")"
    cp -p "$file_path" "$TMP_DIR/$rel_path"
  done < <(find "$skill_dir" -type f ! -name '.DS_Store' | sort)
done < <(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d ! -name '.system' | sort)

while IFS= read -r dir_path; do
  if ! find "$dir_path" -mindepth 1 -maxdepth 1 | read -r _; then
    touch "$dir_path/.gitkeep"
  fi
done < <(find "$TMP_DIR" -type d | sort)

if [ -d "$ARCHIVE_DIR" ] && diff -qr "$TMP_DIR" "$ARCHIVE_DIR" >/dev/null; then
  echo "Skills archive is already consistent with GitHub. No commit needed."
  exit 0
fi

rm -rf "$ARCHIVE_DIR"
mkdir -p "$ARCHIVE_DIR"
cp -R "$TMP_DIR"/. "$ARCHIVE_DIR"/

git add "$ARCHIVE_SUBDIR" "$0"

if git diff --cached --quiet -- "$ARCHIVE_SUBDIR" "$0"; then
  echo "No archive changes to commit."
  exit 0
fi

git commit -m "Archive skills snapshot ($TIMESTAMP)"
git push "$REMOTE" "$BRANCH"

echo "Archived skills to $REMOTE/$BRANCH"
