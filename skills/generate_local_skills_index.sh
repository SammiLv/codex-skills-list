#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${HOME}/.codex/skills"
OUTPUT_FILE="${1:-/Users/sammilv/Documents/New project/skills/LOCAL_SKILLS_INDEX.md}"
TIMESTAMP="$(TZ=Asia/Shanghai date '+%Y-%m-%d %H:%M:%S %Z')"
TMP_FILE="$(mktemp)"

mkdir -p "$(dirname "$OUTPUT_FILE")"

{
  printf '# Local Skills Index\n\n'
  printf 'Auto-generated from `%s`.\n\n' "$SKILLS_DIR"
  printf -- '- Last updated: `%s`\n' "$TIMESTAMP"
  printf -- '- Trigger convention: use `$skill-name` to explicitly invoke a local skill.\n'
  printf -- '- Scope: custom local skills only; built-in system skills and plugin skills are excluded.\n\n'
  printf '## Skill List\n\n'

  found_any=0

  while IFS= read -r skill_dir; do
    skill_file="$skill_dir/SKILL.md"
    [ -f "$skill_file" ] || continue

    found_any=1

    name="$(sed -n 's/^name:[[:space:]]*//p' "$skill_file" | head -n 1)"
    description="$(sed -n 's/^description:[[:space:]]*//p' "$skill_file" | head -n 1)"
    purpose="$(awk '
      /^## Purpose$/ { in_purpose=1; next }
      /^## / && in_purpose { exit }
      in_purpose && NF {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
        print
        exit
      }
    ' "$skill_file")"

    if [ -z "$name" ]; then
      name="$(basename "$skill_dir")"
    fi

    if [ -z "$description" ]; then
      description='No description found in front matter.'
    fi

    if [ -z "$purpose" ]; then
      purpose='No purpose summary found.'
    fi

    printf '### %s\n\n' "$name"
    printf -- '- Trigger: `$%s`\n' "$name"
    printf -- '- Path: `%s`\n' "$skill_file"
    printf -- '- Description: %s\n' "$description"
    printf -- '- Purpose: %s\n\n' "$purpose"
  done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d ! -name '.system' | sort)

  if [ "$found_any" -eq 0 ]; then
    printf 'No custom local skills found.\n'
  fi
} > "$TMP_FILE"

mv "$TMP_FILE" "$OUTPUT_FILE"
printf 'Updated %s\n' "$OUTPUT_FILE"
