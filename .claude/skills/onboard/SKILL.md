---
name: onboard
description: >
  One-command project onboarding. Scans tech stack, maps architecture,
  generates CLAUDE.md, initializes Memory Bank, reports warnings.
  Use when: "onboard", "setup project", "initialize", "get started",
  "make project-aware", "scan project"
argument-hint: "[--skip-memory] [--dry-run]"
user-invocable: true
---

# /onboard - Project Onboarding

$ARGUMENTS

---

## Purpose

One command to make your AI assistant fully project-aware. Scans the project, detects tech stack, maps architecture, generates a project-specific CLAUDE.md, initializes Memory Bank, and reports potential issues.

---

## Behavior

When `/onboard` is triggered:

### Phase 1: Tech Stack Detection

Scan for manifest files and detect:

| File | Detects |
|------|---------|
| `package.json` | Node.js, framework (next, react, vue, svelte, express), dependencies, scripts, package manager |
| `requirements.txt` / `pyproject.toml` / `setup.py` | Python, framework (django, fastapi, flask) |
| `go.mod` | Go, modules |
| `Cargo.toml` | Rust, crates |
| `pubspec.yaml` | Flutter/Dart |
| `Gemfile` | Ruby on Rails |
| `docker-compose.yml` / `Dockerfile` | Containerization |
| `tsconfig.json` | TypeScript config |
| `.env.example` / `.env.local` | Environment variables |

Also detect:
- **Package manager**: lockfile priority (pnpm-lock.yaml > yarn.lock > package-lock.json > bun.lockb)
- **Test runner**: jest.config, vitest.config, pytest.ini, .mocharc
- **Linter**: .eslintrc, .prettierrc, ruff.toml, .flake8
- **CI/CD**: .github/workflows/, .gitlab-ci.yml, Jenkinsfile
- **Database**: prisma/schema.prisma, drizzle.config, alembic.ini, migrations/

### Phase 2: Architecture Mapping

Read the directory structure and identify:
- **Entry points**: src/index.ts, app/layout.tsx, main.py, cmd/main.go
- **Project pattern**: monorepo (packages/), feature-based (src/features/), domain-driven (src/domain/), flat
- **Key directories**: what each top-level directory does
- **Config files**: summarize important configs (next.config, vite.config, webpack.config)
- **API routes**: src/app/api/, routes/, controllers/

### Phase 3: Key File Summary

Read and summarize (1-2 lines each):
- Entry point files
- Main config files
- Schema/model files (prisma schema, models/, types/)
- Existing README.md (if any)

### Phase 4: Generate Project CLAUDE.md

Create or update `CLAUDE.md` in the project root with project-specific rules:

```markdown
# Project: {detected project name}

## Tech Stack
- **Language:** {language} {version if detectable}
- **Framework:** {framework} {version}
- **Database:** {database} via {ORM}
- **Package Manager:** {pm}
- **Test Runner:** {runner}
- **Linter:** {linter}

## Commands
- **Dev:** {dev command from package.json scripts or detected}
- **Build:** {build command}
- **Test:** {test command}
- **Lint:** {lint command}

## Architecture
- **Pattern:** {monorepo / feature-based / domain-driven / flat}
- **Entry Point:** {path}
- **Key Directories:**
  - `src/features/` — Feature modules
  - `src/lib/` — Shared utilities
  - `prisma/` — Database schema and migrations

## Conventions
- **Naming:** {detected from existing code: camelCase, snake_case, etc.}
- **Imports:** {absolute with @/ alias, relative, etc.}
- **Components:** {functional, class, file-per-component, etc.}

## Notes
{Any project-specific notes detected from existing README or comments}
```

**IMPORTANT:** If a CLAUDE.md already exists, do NOT overwrite it. Instead:
- Read existing content
- Add a `## Project Context (auto-generated)` section at the end
- Preserve all existing rules

### Phase 5: Initialize Memory Bank

Run `/remember` internally to create:
- `MEMORY-activeContext.md`
- `MEMORY-patterns.md`
- `MEMORY-decisions.md`
- `MEMORY-troubleshooting.md`

### Phase 6: Warnings & Recommendations

Check and report:

| Check | Warning If |
|-------|-----------|
| `.gitignore` | Missing or doesn't include node_modules/.env |
| `.env` in git | `.env` file is tracked (secret leak risk) |
| Tests | No test files found anywhere |
| Linter config | No linter configuration found |
| CI/CD | No CI/CD pipeline configured |
| TypeScript | JS project without tsconfig (recommend migration) |
| `.env.example` | `.env` exists but `.env.example` doesn't |
| Lock file | Multiple lock files detected (npm + yarn conflict) |

---

## Output Format

```
══════════════════════════════════════
  BDK Onboarding Complete
══════════════════════════════════════

  Project:          {name}
  Stack:            {framework} + {language} + {database}
  Package Manager:  {pm}
  Test Runner:      {runner}
  Linter:           {linter}
  Architecture:     {pattern}

  Generated:
  ✓ CLAUDE.md          (project-specific rules)
  ✓ Memory Bank        (4 files initialized)

  Warnings:
  ⚠ No CI/CD pipeline found
  ⚠ Missing .env.example

  Your AI assistant is now project-aware.
══════════════════════════════════════
```

---

## Examples

```
/onboard                    # Full onboarding for current project
/onboard --skip-memory      # Skip Memory Bank initialization
/onboard --dry-run          # Show what would be generated without writing files
```

---

## Key Principles

- **Non-destructive** — never overwrite existing CLAUDE.md, only append
- **Detection over assumption** — only report what is actually found
- **Concise output** — project context should fit in one screen
- **Actionable warnings** — every warning includes what to do about it