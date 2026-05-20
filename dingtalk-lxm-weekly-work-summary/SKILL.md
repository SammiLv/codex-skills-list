---
name: dingtalk-lxm-weekly-work-summary
description: Use when the user wants a weekly work summary for Lu Xiamiao (吕夏苗) based on all available DingTalk MCP evidence, including chats and @mentions when accessible, OA approvals, todos, calendar events, logs, documents, spreadsheets, contacts, and group metadata. Default range is the 7-day period ending on the current date.
---

# DingTalk Lu Xiamiao Weekly Work Summary

## Purpose

Use this skill to summarize `吕夏苗`'s weekly work from DingTalk evidence. The report owner is fixed as `吕夏苗` unless the user explicitly names another subject.

Default period: the 7 calendar days ending on the current date in `Asia/Shanghai`. If the user says `本周`, `上周`, or gives explicit dates, use that range instead and state exact start/end dates in the result.

## Evidence Scope

Use every available DingTalk MCP source that can provide relevant evidence. Prefer read-only tools. Do not create, update, send, approve, revoke, delete, or modify DingTalk data unless the user explicitly asks.

Collect from these sources when the corresponding MCP tools are available:

1. `contacts`: identify the current user and relevant people by searching `吕夏苗`, known aliases, and names found in evidence.
2. `calendar`: query all calendar events in the date range; inspect details and participants for meetings, reviews, trainings, project discussions, and coordination work.
3. `ToDo`: query current-user todos; use completed, pending, high-priority, and overdue todos as work evidence when they fall in or clearly relate to the range.
4. `OAapproval`: query submitted, pending, processed, and copied approvals; fetch details for relevant instances and summarize only business-relevant approval actions.
5. `log`: query sent and received logs in the range; inspect details where titles or summaries suggest weekly reports, project progress, blockers, or decisions.
6. `doc`, `excel`, and `AIexcel`: search or inspect DingTalk documents, spreadsheets, and AI tables only when project names, meeting titles, approval titles, or todo titles suggest relevant work details.
7. `robotmessage` and `groupchat`: use group search and group metadata to locate likely work groups or project groups. Do not send robot messages or create groups.
8. Chat records and `@我`: when a chat-history MCP is available, query direct chats, group chats, and messages where `吕夏苗` is mentioned. If MCP chat history is not available, use DingTalk desktop via Computer Use only if the user has asked for a live run and the UI is accessible.

### Chat and Group Evidence Requirement

For each run, actively check whether the current tool session exposes read-only DingTalk chat-history capabilities, including group messages, direct messages, and `@我` / mentions. Do not assume group-message access is unavailable from prior runs.

If chat/group-message tools are available:

- Query work-relevant group chats, direct chats, and `@吕夏苗` / `@我` messages within the report range.
- Use group names, project names, meeting titles, approval titles, todo titles, and names discovered from structured evidence as search keywords.
- Include only work-attributable evidence: messages sent by `吕夏苗`, messages explicitly assigning or mentioning her responsibility, decisions she made, blockers she handled, commitments she gave, or follow-ups assigned to her.
- Paraphrase private chat content; do not quote sensitive chat text unless strictly necessary.
- Add every usable chat item to the evidence ledger with source names such as `群聊 / 群名` or `单聊 / 人名`.

If chat/group-message tools are not available:

- State the exact limitation in `未覆盖/受限来源`, for example `当前未暴露群消息/聊天记录/@我读取接口`.
- Do not silently omit chat/group evidence.
- Do not create groups, send robot messages, or use write-only group tools as substitutes for evidence collection.

## Collection Workflow

1. Compute the exact range in Beijing time and keep millisecond timestamps for MCP calls.
2. Establish identity:
   - default owner name: `吕夏苗`
   - if available, find the corresponding DingTalk userId through contacts or evidence details
   - do not infer another report owner from frequent names in groups
3. Query core sources first:
   - calendar events in the range
   - todos
   - OA approvals: submitted, pending/todo, processed/done, copied/notified
   - logs sent and received
4. Search communication evidence:
   - direct chats involving the owner
   - group chats with owner messages or `@吕夏苗` / `@我`
   - project groups discovered through group search
5. Expand by keywords from the evidence:
   - project names, customer names, system names, requirement names, approval titles, meeting titles, todo subjects
   - inspect related docs/spreadsheets only when they can clarify work content, status, metrics, decisions, or blockers
6. Build an evidence ledger before writing the summary.

## Evidence Ledger

Track every usable item in this shape:

`日期｜事项｜来源｜证据类型｜归属判断｜状态/结果`

Rules:

- Use compact source names such as `钉钉日程 / 会议标题`, `OA审批 / 审批标题`, `待办 / 任务标题`, `群聊 / 群名`, `单聊 / 人名`, `日志 / 日志标题`, `文档 / 文档名`.
- Do not overquote private chat text. Paraphrase decisions, blockers, commitments, and outcomes.
- Keep only work attributable to `吕夏苗`: messages she sent, items assigned to her, approvals she submitted/handled, meetings she organized or attended, todos she owns or executes, and work where she is explicitly mentioned as responsible.
- Ignore pure notifications, system messages, step counts, and generic reminders unless they directly explain a work item.
- When evidence conflicts, prefer primary structured records in this order: approval/detail records, calendar/detail records, todo/detail records, logs/docs, then chat summaries. Note unresolved uncertainty briefly.

## Classification

Group atomic work items into these sections unless the user asks for another format:

- `发现与解决问题`: issue discovery, diagnosis, troubleshooting, risk handling, process correction, optimization.
- `业务与培训`: requirements, launches, project delivery, customer/business support, content/material work, training participation.
- `管理与协作`: cross-team alignment, meetings, reviews, scheduling, follow-ups, resource coordination, approval coordination.
- `学习与创新`: tool exploration, AI use, reusable workflows, process automation, new methods.

Avoid duplicating the same item across sections. Put it in the best-fit section and reference supporting sources in the ledger.

## Output

Default response in Chinese:

1. Title: `吕夏苗钉钉周工作总结（YYYY年M月D日-YYYY年M月D日）`
2. `本周概览`: 3-5 sentences summarizing the main work themes and outcomes.
3. Four fixed sections:
   - one concise paragraph
   - numbered points using `1、2、3、`
4. `证据台账`: include when the user asks for traceability, when evidence is mixed across many MCP services, or when confidence would benefit from source visibility.
5. `未覆盖/受限来源`: list MCP services or chat sources that were unavailable, inaccessible, or returned no relevant data.

Write formally enough to paste into a weekly report. Be concrete: include project names, meeting titles, approval/todo/log titles, deliverables, decisions, and follow-up status when available.

## DingTalk Document Publishing

When the user asks to publish the report to DingTalk Docs with a fixed document name, use replacement semantics:

Default fixed document name: `吕夏苗钉钉周工作总结（mcp）`. Do not use `吕夏苗个人周工作总结（mcp）` unless the user explicitly overrides the name.

1. List the target folder with `list_nodes`.
2. Find every direct child node whose `name` exactly matches the requested document name.
3. Delete all exact same-name nodes before creating the new report document.
4. Create a fresh DingTalk online document with the requested fixed name and the final Markdown content.
5. Read back the created document and report its URL.

Do not overwrite an existing same-name document. Do not create a duplicate that DingTalk auto-renames with suffixes such as `(1)`. If the current session does not expose a DingTalk document deletion tool or deletion fails, stop before publishing and report the blocker clearly; do not fall back to overwrite, rename, or duplicate creation.

## Safety

- Read-only by default.
- Do not send DingTalk messages, create robots, create groups, change todos, modify approvals, create logs, delete documents, create documents, or edit documents unless explicitly requested. When the user explicitly requests DingTalk Docs publication, document deletion and creation are allowed only for exact same-name replacement in the requested target folder.
- Do not expose unnecessary personal or sensitive chat content. Summarize only work-relevant facts.
- If a tool needs a `processCode` or similar schema identifier that is not known, first call the corresponding list/visible-process tool, then query likely forms.
