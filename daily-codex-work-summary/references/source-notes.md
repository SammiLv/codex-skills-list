# Source Notes

Use these local files as evidence for daily Codex summaries:

- `${CODEX_HOME:-~/.codex}/sessions/YYYY/MM/DD/*.jsonl`: per-session transcript files. These usually contain `session_meta`, `turn_context`, `event_msg`, and `response_item` records.
- `${CODEX_HOME:-~/.codex}/session_index.jsonl`: lightweight index with `id`, `thread_name`, and `updated_at`.

Useful `response_item` patterns:

- `payload.type == "message"` and `payload.role == "user"`: user requests and clarifications.
- `payload.type == "message"` and `payload.role == "assistant"`: progress updates and final responses. Prefer final responses over intermediate commentary.
- Tool call records can reveal changed files or verification commands, but avoid dumping raw outputs into the report.

Filtering guidance:

- Ignore environment context blocks except for current date, timezone, and cwd.
- Ignore system/developer instruction text.
- Treat thread titles as hints, not ground truth.
- If a transcript was created near UTC midnight, rely on the local dated folder first, then timestamps if the user asks for strict timezone handling.
