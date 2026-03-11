---
description: Project onboarding. Scans tech stack, maps architecture, generates CLAUDE.md, initializes Memory Bank.
---

# /onboard - Project Onboarding

$ARGUMENTS

---

## Purpose

One command to make your AI assistant fully project-aware. Run this after adding BDK to a new project.

---

## Task

Execute the following phases in order:

### Phase 1: Detect Tech Stack
- Scan for: package.json, requirements.txt, go.mod, Cargo.toml, pubspec.yaml, Gemfile
- Identify: language, framework, database, ORM, package manager, test runner, linter
- Read package.json scripts for dev/build/test/lint commands

### Phase 2: Map Architecture
- Read directory structure (top 3 levels)
- Identify project pattern: monorepo, feature-based, domain-driven, or flat
- Find entry points, API routes, schema files, config files

### Phase 3: Summarize Key Files
- Read and summarize entry points, main configs, schema/model files (1-2 lines each)

### Phase 4: Generate CLAUDE.md
- If CLAUDE.md exists: append `## Project Context (auto-generated)` section, preserve existing content
- If CLAUDE.md doesn't exist: create full project-specific CLAUDE.md
- Include: tech stack, commands, architecture pattern, conventions, key directories

### Phase 5: Initialize Memory Bank
- Run `/remember` to create MEMORY-activeContext.md, MEMORY-patterns.md, MEMORY-decisions.md, MEMORY-troubleshooting.md

### Phase 6: Report Warnings
Check for: missing .gitignore, .env in git, no tests, no linter, no CI/CD, missing .env.example, multiple lock files

---

## Output

Report a summary with: project name, stack, package manager, test runner, linter, architecture pattern, generated files, and warnings.

---

## Examples

```
/onboard
/onboard --skip-memory
/onboard --dry-run
```
