#!/usr/bin/env python3
"""Collect readable Codex session excerpts for a daily work summary."""

from __future__ import annotations

import argparse
import datetime as dt
import glob
import json
import os
import re
from pathlib import Path
from typing import Any


def codex_home(value: str | None) -> Path:
    if value:
        return Path(value).expanduser()
    return Path(os.environ.get("CODEX_HOME", "~/.codex")).expanduser()


def load_index(home: Path) -> dict[str, dict[str, Any]]:
    index_path = home / "session_index.jsonl"
    out: dict[str, dict[str, Any]] = {}
    if not index_path.exists():
        return out
    with index_path.open("r", encoding="utf-8") as handle:
        for line in handle:
            try:
                item = json.loads(line)
            except json.JSONDecodeError:
                continue
            session_id = item.get("id")
            if session_id:
                out[session_id] = item
    return out


def text_from_message(payload: dict[str, Any]) -> str:
    parts: list[str] = []
    for content in payload.get("content", []):
        if not isinstance(content, dict):
            continue
        if content.get("type") in {"input_text", "output_text"}:
            text = content.get("text") or ""
            if text.startswith("<environment_context>"):
                continue
            parts.append(text.strip())
    return "\n".join(part for part in parts if part)


SENSITIVE_PATTERNS = [
    (re.compile(r"(?i)(key|token|access_token|api_key|secret|password)=([^\\s&\"']+)"), r"\1=[REDACTED]"),
    (re.compile(r"(?i)(bearer\\s+)[A-Za-z0-9._~+/=-]+"), r"\1[REDACTED]"),
    (re.compile(r"(sk-[A-Za-z0-9_-]{12,})"), "[REDACTED]"),
    (re.compile(r"\\b[a-f0-9]{48,}\\b", re.IGNORECASE), "[REDACTED]"),
]


def redact(text: str) -> str:
    for pattern, replacement in SENSITIVE_PATTERNS:
        text = pattern.sub(replacement, text)
    return text


def trim(text: str, limit: int) -> str:
    text = redact(text)
    text = " ".join(text.split())
    if len(text) <= limit:
        return text
    return text[: max(0, limit - 1)].rstrip() + "..."


def parse_session(path: Path, index: dict[str, dict[str, Any]], excerpt_limit: int) -> dict[str, Any]:
    meta: dict[str, Any] = {}
    users: list[str] = []
    assistants: list[str] = []
    tool_hints: list[str] = []

    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            try:
                item = json.loads(line)
            except json.JSONDecodeError:
                continue
            payload = item.get("payload", {})
            if item.get("type") == "session_meta" and isinstance(payload, dict):
                meta = payload
                continue
            if item.get("type") != "response_item" or not isinstance(payload, dict):
                continue
            if payload.get("type") == "message":
                role = payload.get("role")
                text = text_from_message(payload)
                if not text:
                    continue
                if role == "user":
                    users.append(text)
                elif role == "assistant":
                    assistants.append(text)
            elif payload.get("type") == "function_call":
                name = payload.get("name")
                args = payload.get("arguments")
                if name:
                    tool_hints.append(trim(f"{name}: {args or ''}", 220))

    session_id = meta.get("id") or path.stem.split("-")[-1]
    indexed = index.get(session_id, {})
    return {
        "id": session_id,
        "path": str(path),
        "title": indexed.get("thread_name") or "(untitled)",
        "started_at": meta.get("timestamp"),
        "updated_at": indexed.get("updated_at"),
        "cwd": meta.get("cwd"),
        "user_requests": [trim(text, excerpt_limit) for text in users[:6]],
        "assistant_final": trim(assistants[-1], excerpt_limit) if assistants else "",
        "tool_hints": tool_hints[:12],
    }


def session_paths(home: Path, date_text: str) -> list[Path]:
    target = dt.date.fromisoformat(date_text)
    pattern = home / "sessions" / f"{target:%Y}" / f"{target:%m}" / f"{target:%d}" / "*.jsonl"
    return [Path(p) for p in sorted(glob.glob(str(pattern)))]


def render_markdown(sessions: list[dict[str, Any]], date_text: str) -> str:
    lines = [f"# Codex activity for {date_text}", ""]
    if not sessions:
        lines.append(f"No local Codex sessions found for {date_text}.")
        return "\n".join(lines)
    for idx, session in enumerate(sessions, 1):
        lines.extend(
            [
                f"## {idx}. {session['title']}",
                f"- Session: `{session['id']}`",
                f"- File: `{session['path']}`",
            ]
        )
        if session.get("cwd"):
            lines.append(f"- CWD: `{session['cwd']}`")
        if session.get("started_at"):
            lines.append(f"- Started: {session['started_at']}")
        if session.get("updated_at"):
            lines.append(f"- Updated: {session['updated_at']}")
        if session["user_requests"]:
            lines.append("- User requests:")
            for request in session["user_requests"]:
                lines.append(f"  - {request}")
        if session["assistant_final"]:
            lines.append(f"- Last assistant outcome: {session['assistant_final']}")
        if session["tool_hints"]:
            lines.append("- Tool hints:")
            for hint in session["tool_hints"]:
                lines.append(f"  - {hint}")
        lines.append("")
    return "\n".join(lines).rstrip()


def main() -> int:
    yesterday = (dt.date.today() - dt.timedelta(days=1)).isoformat()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--date", default=yesterday, help="Local date to collect, YYYY-MM-DD. Defaults to yesterday.")
    parser.add_argument("--codex-home", help="Codex home directory. Defaults to CODEX_HOME or ~/.codex.")
    parser.add_argument("--format", choices=["markdown", "json"], default="markdown")
    parser.add_argument("--excerpt-limit", type=int, default=900)
    args = parser.parse_args()

    home = codex_home(args.codex_home)
    index = load_index(home)
    sessions = [parse_session(path, index, args.excerpt_limit) for path in session_paths(home, args.date)]

    if args.format == "json":
        print(json.dumps({"date": args.date, "sessions": sessions}, ensure_ascii=False, indent=2))
    else:
        print(render_markdown(sessions, args.date))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
