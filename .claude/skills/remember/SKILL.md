---
name: remember
description: >
  Memory Bank system for cross-session persistence.
  Use when: "remember", "save context", "memory bank", "persist",
  "session context", "what did we do", "update memory"
argument-hint: "[context|patterns|decisions|issues|status]"
user-invocable: true
---

# /remember - Memory Bank System

$ARGUMENTS

---

## Purpose

This command creates or updates the project's Memory Bank — a set of persistent context files that survive across sessions. Claude reads these at session start to avoid re-discovering the same information.

---

## Sub-commands

```
/remember              - Full scan: create/update all memory files
/remember context      - Update only active context (what's being worked on now)
/remember patterns     - Update only detected patterns and conventions
/remember decisions    - Update only architecture decisions
/remember issues       - Update only troubleshooting log
/remember status       - Show current memory bank status
```

---

## Behavior

When `/remember` is triggered:

### 1. Scan Project

Auto-collect live context first using tools:

1. **Branch**: Run `git branch --show-current`
2. **Recent commits**: Run `git log --oneline -10`
3. **Changed files**: Run `git diff --name-only HEAD~5`

Then analyze the project to understand:
- **Tech stack**: package.json, requirements.txt, go.mod, Cargo.toml, etc.
- **Architecture**: folder structure, naming conventions, file organization
- **Patterns**: recurring code patterns, import styles, state management approach
- **Recent activity**: git log, recent changes, current branch

### 2. Create/Update Memory Files

Write findings to `.agent/.claude/memory/`:

| File | Content |
|------|---------|
| `MEMORY-activeContext.md` | Current work: branch, recent commits, active feature, blockers |
| `MEMORY-patterns.md` | Numbered patterns: naming conventions, file structure, code style, component patterns |
| `MEMORY-decisions.md` | Architecture Decision Records (ADR): each decision with rationale and date |
| `MEMORY-troubleshooting.md` | Solved issues: problem, root cause, solution, date |

### 3. Preserve History

**CRITICAL RULES:**
- NEVER delete existing entries — only append or update
- Preserve all historical records (ADRs, past patterns, solved issues)
- When updating, add new entries with current date
- Mark outdated patterns as `[DEPRECATED]` instead of removing

---

## Memory File Formats

### MEMORY-activeContext.md
```markdown
# Active Context
> Last updated: {date}

## Current Work
- **Branch:** {current branch}
- **Feature:** {what's being built/fixed}
- **Status:** {in progress / blocked / review}

## Recent Sessions
### {date}
- {what was done}
- {decisions made}
- {blockers encountered}
```

### MEMORY-patterns.md
```markdown
# Project Patterns
> Last updated: {date}

## Tech Stack
- {framework, language, key libraries}

## Patterns

### Pattern 1: {Name}
- **Where:** {files/directories}
- **Convention:** {description}
- **Example:** {brief code reference}

### Pattern 2: {Name}
...
```

### MEMORY-decisions.md
```markdown
# Architecture Decisions
> Last updated: {date}

## ADR-001: {Title}
- **Date:** {date}
- **Status:** Accepted
- **Context:** {why this decision was needed}
- **Decision:** {what was decided}
- **Rationale:** {why this approach}

## ADR-002: {Title}
...
```

### MEMORY-troubleshooting.md
```markdown
# Troubleshooting Log
> Last updated: {date}

## Issue 1: {Title}
- **Date:** {date}
- **Symptom:** {what went wrong}
- **Root Cause:** {why it happened}
- **Solution:** {how it was fixed}

## Issue 2: {Title}
...
```

---

## Output

After completing, report:

```
Memory Bank updated:
- MEMORY-activeContext.md    [created/updated]
- MEMORY-patterns.md         [created/updated]
- MEMORY-decisions.md        [created/updated]
- MEMORY-troubleshooting.md  [created/updated]

Next session will auto-load this context.
```

---

## Examples

```
/remember
/remember context
/remember patterns
/remember decisions
/remember issues
/remember status
```

---

## Key Principles

- **Append-only** — never delete history, only add
- **Concise** — keep entries short, no verbose prose
- **Factual** — record what happened, not speculation
- **Actionable** — patterns and solutions should be directly reusable
