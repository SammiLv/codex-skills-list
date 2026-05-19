# Custom Local Skills

Auto-generated from `/Users/sammilv/.codex/skills`.

- Last updated: `2026-05-15 15:35:34 CST`
- Trigger convention: use `$skill-name` to explicitly invoke a local skill.
- Scope: custom local skills only.
- Excluded: built-in system skills and plugin skills.

## Skill List

### daily-codex-work-summary

- Trigger: `$daily-codex-work-summary`
- Path: `/Users/sammilv/.codex/skills/daily-codex-work-summary/SKILL.md`
- Description: Generate a daily Chinese work summary from the user's Codex activity, defaulting to yesterday's work, and display the summary in the current conversation. Use when the user asks to summarize what they did in Codex yesterday, today, on a specific date, or asks for a daily Codex work report, Codex daily review, work log, or end-of-day recap based on Codex sessions.
- Purpose: No purpose summary found.

### dingtalk-lxm-weekly-work-summary

- Trigger: `$dingtalk-lxm-weekly-work-summary`
- Path: `/Users/sammilv/.codex/skills/dingtalk-lxm-weekly-work-summary/SKILL.md`
- Description: Use when the user wants a weekly work summary for Lu Xiamiao (吕夏苗) based on all available DingTalk MCP evidence, including chats and @mentions when accessible, OA approvals, todos, calendar events, logs, documents, spreadsheets, contacts, and group metadata. Default range is the 7-day period ending on the current date.
- Purpose: Use this skill to summarize `吕夏苗`'s weekly work from DingTalk evidence. The report owner is fixed as `吕夏苗` unless the user explicitly names another subject.

### dingtalk-personal-weekly-report

- Trigger: `$dingtalk-personal-weekly-report`
- Path: `/Users/sammilv/.codex/skills/dingtalk-personal-weekly-report/SKILL.md`
- Description: Use when the user wants a personal weekly report generated from DingTalk communication records and calendar events, especially chat/group-chat based work summaries that need to be organized into the four sections 发现与解决问题、业务与培训、管理与协作、学习与创新, with optional traceable ledger items and DingTalk Docs output.
- Purpose: No purpose summary found.

### personal-skill-inventory

- Trigger: `$personal-skill-inventory`
- Path: `/Users/sammilv/.codex/skills/personal-skill-inventory/SKILL.md`
- Description: Use when the user wants to list, audit, summarize, document, or update a registry of their personal Codex skills, including each skill's name, location, overview, and trigger conditions. Trigger this skill for requests such as "我有哪些个人 skill", "记录我创建的 skills", "列出每个 skill 的概述和触发器", "整理 skill 清单", or "更新个人 skill 目录".
- Purpose: No purpose summary found.

### reserve-dingtalk-meeting

- Trigger: `$reserve-dingtalk-meeting`
- Path: `/Users/sammilv/.codex/skills/reserve-dingtalk-meeting/SKILL.md`
- Description: Use when the user invokes $预约会议 or asks to automatically create a DingTalk meeting from a meeting time and invited people. The skill should default the meeting title when omitted, query DingTalk room availability, choose the best available room by attendee count, create the calendar meeting, book the room, invite attendees, and return the final meeting details.
- Purpose: No purpose summary found.

### weekly-codex-work-summary

- Trigger: `$weekly-codex-work-summary`
- Path: `/Users/sammilv/.codex/skills/weekly-codex-work-summary/SKILL.md`
- Description: Generate a Chinese weekly work summary from the user's local Codex activity, defaulting to the current week, and display it in the current conversation. Use when the user asks to summarize what they did in Codex this week, last week, over a date range, or asks for a Codex weekly report, weekly review, work log, or recap based on Codex sessions.
- Purpose: No purpose summary found.

### 产品部周报汇总

- Trigger: `$产品部周报汇总`
- Path: `/Users/sammilv/.codex/skills/weekly-report-summary/SKILL.md`
- Description: Use when the user invokes $产品部周报汇总 to archive received weekly reports into DingTalk docs first, then summarize them into a department weekly report using the fixed 产品部周报汇总 template.
- Purpose: Use this skill to process multiple received work reports and produce:

