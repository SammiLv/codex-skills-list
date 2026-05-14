# Custom Local Skills

Auto-generated from `/Users/sammilv/.codex/skills`.

- Last updated: `2026-05-14 15:53:55 CST`
- Trigger convention: use `$skill-name` to explicitly invoke a local skill.
- Scope: custom local skills only.
- Excluded: built-in system skills and plugin skills.

## Skill List

### dingtalk-personal-weekly-report

- Trigger: `$dingtalk-personal-weekly-report`
- Path: `/Users/sammilv/.codex/skills/dingtalk-personal-weekly-report/SKILL.md`
- Description: Use when the user wants a personal weekly report generated from DingTalk communication records and calendar events, especially chat/group-chat based work summaries that need to be organized into the four sections 发现与解决问题、业务与培训、管理与协作、学习与创新, with optional traceable ledger items and DingTalk Docs output.
- Purpose: No purpose summary found.

### reserve-dingtalk-meeting

- Trigger: `$reserve-dingtalk-meeting`
- Path: `/Users/sammilv/.codex/skills/reserve-dingtalk-meeting/SKILL.md`
- Description: Use when the user invokes $预约会议 or asks to automatically create a DingTalk meeting from a meeting time and invited people. The skill should default the meeting title when omitted, query DingTalk room availability, choose the best available room by attendee count, create the calendar meeting, book the room, invite attendees, and return the final meeting details.
- Purpose: No purpose summary found.

### 产品部周报汇总

- Trigger: `$产品部周报汇总`
- Path: `/Users/sammilv/.codex/skills/weekly-report-summary/SKILL.md`
- Description: Use when the user invokes $产品部周报汇总 to archive received weekly reports into DingTalk docs first, then summarize them into a department weekly report using the fixed 产品部周报汇总 template.
- Purpose: Use this skill to process multiple received work reports and produce:

