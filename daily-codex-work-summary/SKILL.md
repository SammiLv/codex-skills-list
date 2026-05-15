---
name: daily-codex-work-summary
description: Generate a daily Chinese work summary from the user's Codex activity, defaulting to yesterday's work, and display the summary in the current conversation. Use when the user asks to summarize what they did in Codex yesterday, today, on a specific date, or asks for a daily Codex work report, Codex daily review, work log, or end-of-day recap based on Codex sessions.
---

# Daily Codex Work Summary

## Overview

Create a concise, useful Chinese daily report from local Codex session records and display it in the current conversation. Focus on what the user asked Codex to do, what was completed, what files or artifacts were created or changed, what was verified, and what follow-ups remain.

## Workflow

1. Resolve the target date.
   - Default to yesterday's local date from the active environment context.
   - Respect explicit dates such as "今天", "上周五", or "2026-05-15"; clarify with absolute dates when there is ambiguity.

2. Gather local Codex activity.
   - Prefer running `scripts/collect_codex_activity.py --format markdown` for the default yesterday summary.
   - Use `scripts/collect_codex_activity.py --date YYYY-MM-DD --format markdown` when the user asks for a specific date.
   - The script reads `${CODEX_HOME:-~/.codex}/sessions/YYYY/MM/DD/*.jsonl` and `${CODEX_HOME:-~/.codex}/session_index.jsonl`.
   - If the script cannot run, manually inspect the same files. Do not use network access.

3. Read only the relevant parts of sessions.
   - Prioritize user prompts, final assistant messages, file paths, commands that produced deliverables, and verification results.
   - Skip long system/developer instructions, repeated progress updates, raw tool dumps, and sensitive auth/config contents.
   - If a session is too large, sample the beginning user request, important mid-session user clarifications, and the last assistant answer.

4. Summarize by work, not by transcript.
   - Merge multiple sessions about the same task into one item.
   - Prefer concrete outcomes over chat mechanics.
   - Distinguish completed work, partial work, blocked work, and investigation only.

5. Display the final summary directly in the current conversation.

6. Output in Chinese unless the user asks otherwise.

## Report Format

Use this format by default:

```markdown
## YYYY-MM-DD

**Codex 工作日报｜YYYY-MM-DD**

昨天主要完成了：

1. 项目/主题：一句话说明做了什么。
   产出：列出关键文件、文档、skill、脚本、页面或结论。
   验证：列出运行过的检查；如果没有验证，写“未单独验证”。

2. ...

**待跟进**
- 明确的下一步、风险或需要用户确认的事项；没有就写“暂无明确待跟进项”。
```

For a shorter user request, return a compact paragraph plus bullets. For a detailed request, include sections for "完成事项", "产出物", "验证情况", and "待跟进".

## Quality Bar

- Be specific enough that the user can remember the day's work without reopening every thread.
- Mention paths only when they are useful deliverables or changed files.
- Keep speculation out of the report. Use "看起来" or "可能" only when the session evidence is incomplete.
- Preserve privacy: do not quote secrets, tokens, private config values, or long message bodies.
- If no Codex sessions are found for the target date, say that clearly and mention which local date was checked.

## Resources

- `scripts/collect_codex_activity.py`: Collects session metadata and readable excerpts for a target date.
- `references/source-notes.md`: Notes about the local Codex files this skill expects.
