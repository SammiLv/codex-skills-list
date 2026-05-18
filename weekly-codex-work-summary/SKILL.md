---
name: weekly-codex-work-summary
description: Generate a Chinese weekly work summary from the user's local Codex activity, defaulting to the current week, and display it in the current conversation. Use when the user asks to summarize what they did in Codex this week, last week, over a date range, or asks for a Codex weekly report, weekly review, work log, or recap based on Codex sessions.
---

# Weekly Codex Work Summary

## Overview

Create a concise, useful Chinese weekly report from local Codex session records. Focus on the user's actual work themes, completed outcomes, created or changed artifacts, verification, and follow-ups.

## Workflow

1. Resolve the target week or date range.
   - Default to the current local week, Monday through today.
   - Respect explicit requests such as "本周", "上周", "这周", "最近一周", or "2026-05-11 到 2026-05-15".
   - Clarify with absolute dates when relative dates could be confusing.

2. Gather local Codex activity.
   - Prefer running `scripts/collect_codex_week_activity.py --format markdown` for the default current-week summary.
   - Use `scripts/collect_codex_week_activity.py --week last --format markdown` for last week.
   - Use `scripts/collect_codex_week_activity.py --start YYYY-MM-DD --end YYYY-MM-DD --format markdown` for a custom range.
   - The script reads `${CODEX_HOME:-~/.codex}/sessions/YYYY/MM/DD/*.jsonl` and `${CODEX_HOME:-~/.codex}/session_index.jsonl`.
   - If the script cannot run, manually inspect the same files. Do not use network access.

3. Read only relevant evidence.
   - Prioritize user prompts, final assistant messages, file paths, commands that produced deliverables, and verification results.
   - Skip long system/developer instructions, repeated progress updates, raw tool dumps, and sensitive auth/config contents.
   - If a session is too large, sample the first user request, important user clarifications, and the last assistant answer.

4. Summarize by workstream, not by transcript.
   - Merge multiple sessions about the same project or task into one weekly item.
   - Prefer concrete outcomes over chat mechanics.
   - Distinguish completed work, partial work, blocked work, and investigation-only work.
   - Keep dates as supporting context, not the main structure, unless the user asks for a day-by-day report.

5. Display the final summary directly in the current conversation.

6. Output in Chinese unless the user asks otherwise.

## Report Format

Use this format by default:

```markdown
**Codex 工作周报｜YYYY-MM-DD 至 YYYY-MM-DD**

本周主要完成了：

1. 项目/主题：一句话说明做了什么。
   产出：列出关键文件、文档、skill、脚本、页面或结论。
   验证：列出运行过的检查；如果没有验证，写“未单独验证”。

2. ...

**本周重点产出**
- 可交付文件、页面、脚本、skill、文档或明确结论。

**待跟进**
- 明确的下一步、风险或需要用户确认的事项；没有就写“暂无明确待跟进项”。
```

For a shorter user request, return a compact paragraph plus bullets. For a detailed request, include sections for "完成事项", "产出物", "验证情况", and "待跟进".

## Quality Bar

- Be specific enough that the user can remember the week's work without reopening every thread.
- Mention paths only when they are useful deliverables or changed files.
- Preserve privacy: do not quote secrets, tokens, private config values, or long message bodies.
- Keep speculation out of the report. Use "看起来" or "可能" only when the session evidence is incomplete.
- If no Codex sessions are found for the target range, say that clearly and mention the exact dates checked.

## Resources

- `scripts/collect_codex_week_activity.py`: Collects session metadata and readable excerpts for a target week or date range.
- `references/source-notes.md`: Notes about the local Codex files this skill expects.
