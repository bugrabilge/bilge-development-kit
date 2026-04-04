---
name: push
description: >
  Safe push pipeline: pre-push checks, test validation, smart commit, and push.
  Use when: "push", "commit and push", "ship it", "pushla", "gönder",
  "commit", "hazırla ve gönder"
argument-hint: "[check|--force|--amend]"
user-invocable: true
disable-model-invocation: true
---

# /push - Safe Push Pipeline

$ARGUMENTS

---

## Purpose

All-in-one command that validates code quality, ensures test coverage, generates a meaningful commit message, and pushes to remote. Prevents broken code, leaked secrets, and lazy commits from reaching the repository.

---

## Sub-commands

```
/push              - Full pipeline: check → stage → commit → push
/push check        - Run all checks without committing or pushing
/push --force      - Skip checks (shows warning, requires confirmation)
/push --amend      - Amend last commit and force-push (shows warning)
```

---

## Behavior

When `/push` is triggered:

### Phase 1: Pre-Push Checks

Run these checks sequentially. **Stop on any Critical failure.**

#### 1.1 Branch Safety
```
Run: git branch --show-current
```
| Condition | Action |
|-----------|--------|
| Branch is `main` or `master` | **WARN**: "Direkt main'e push ediyorsun. Emin misin?" — Kullanıcı onayı gerekli |
| Branch is behind remote | **WARN**: "Remote'da yeni commit'ler var. Önce `git pull` önerilir" |
| Branch is up to date | **OK** |

#### 1.2 Secret Scan
```
Search staged files for:
- API keys: /[A-Za-z0-9_]{20,}/ in suspicious contexts
- Passwords: password\s*=\s*["'][^"']+
- Tokens: token\s*=\s*["'][^"']+
- AWS keys: AKIA[0-9A-Z]{16}
- Private keys: -----BEGIN.*PRIVATE KEY-----
- .env files staged
```
| Finding | Action |
|---------|--------|
| Secret detected | **CRITICAL STOP** — Do NOT proceed. Show file:line and ask user to remove |
| `.env` file staged | **CRITICAL STOP** — "`.env` dosyası commit'e dahil. Kaldır." |
| Clean | **OK** |

#### 1.3 Debug Statement Scan
```
Search staged files for:
- console.log (JS/TS)
- print() without context (Python)
- debugger (JS/TS)
- binding.pry (Ruby)
- dd() (PHP)
```
| Finding | Action |
|---------|--------|
| Debug statements found | **WARN** — List them, ask: "Bunlar kalmalı mı?" |
| Clean | **OK** |

#### 1.4 Lint Check
```
Detect and run project linter:
- package.json has "lint" script → npm run lint
- .eslintrc exists → npx eslint .
- ruff.toml/.flake8 exists → ruff check . / flake8
- No linter → Skip with note
```
| Result | Action |
|--------|--------|
| Lint errors | **WARN** — Show errors, ask: "Düzelteyim mi?" |
| Lint clean | **OK** |
| No linter configured | **SKIP** — Note in report |

#### 1.5 Test Validation
```
Detect and run tests:
- package.json has "test" script → npm test
- pytest.ini / conftest.py exists → pytest
- No tests → Skip with warning
```

**Test Coverage Quality Check:**

After running tests, analyze test files for comprehensiveness:

| Check | What to Look For |
|-------|-----------------|
| **Happy path** | Does the test cover the normal/expected flow? |
| **Error cases** | Are error scenarios tested? (invalid input, network failure, etc.) |
| **Edge cases** | Empty arrays, null values, boundary conditions? |
| **Assertions** | Are there meaningful assertions, not just "doesn't throw"? |
| **New code coverage** | Do changed files have corresponding test files? |

| Result | Action |
|--------|--------|
| Tests pass + comprehensive | **OK** |
| Tests pass but shallow | **WARN** — "Testler geçiyor ama sadece happy path. Edge case eksik: [list]" |
| Tests fail | **STOP** — Show failures, ask: "Düzelteyim mi?" |
| No test files for changed code | **WARN** — "Değişen dosyalar için test yok: [files]" |
| No test runner | **SKIP** — Note in report |

---

### Phase 2: Smart Staging

```
Run: git status --short
Run: git diff --stat
```

| Condition | Action |
|-----------|--------|
| No changes | **STOP** — "Commit edilecek değişiklik yok." |
| Untracked files exist | Ask: "Bu dosyaları da ekleyeyim mi? [list]" |
| All changes clear | Stage relevant files with `git add` |

**NEVER stage:**
- `.env`, `.env.local`, `.env.production`
- `*.pem`, `*.key`, `credentials.json`
- `node_modules/`, `__pycache__/`, `.next/`, `dist/`

---

### Phase 3: Smart Commit Message

Analyze the diff to generate a commit message:

#### 3.1 Detect Change Type
| Signal | Prefix |
|--------|--------|
| New files created | `feat:` |
| Existing files modified (functionality) | `feat:` or `refactor:` |
| Bug fix (error handling, condition fix) | `fix:` |
| Test files only | `test:` |
| Docs/README/comments only | `docs:` |
| Config files only (CI, lint, tsconfig) | `chore:` |
| Performance improvements | `perf:` |
| Styling/CSS only | `style:` |

#### 3.2 Generate Message
```
Format: {prefix}: {concise summary}

{optional body - when 5+ files changed}

Rules:
- Subject line: max 72 chars, imperative mood, lowercase after prefix
- Body: what changed and WHY (not just what files)
- NO "Co-Authored-By" lines
- Language: English for commit messages
```

#### 3.3 Show and Confirm
```
Proposed commit message:
─────────────────────────
feat: add push skill with pre-push safety checks

- Add secret scanning, lint check, and test validation
- Generate smart commit messages with conventional commits
- Support --force and --amend flags
─────────────────────────

OK? (Y/N/Edit)
```
- **Y**: Proceed with this message
- **N**: Ask user for their preferred message
- **Edit**: Let user modify the proposed message

---

### Phase 4: Push

```
Run: git push origin {current-branch}
```

| Result | Action |
|--------|--------|
| Push successful | Show success report |
| Push rejected (behind remote) | Run `git pull --rebase` then retry |
| Push rejected (other) | Show error, suggest fix |

---

## Output Format

### Success
```
══════════════════════════════════════
  Push Complete
══════════════════════════════════════

  Branch:    feature/add-push-skill
  Commit:    a1b2c3d feat: add push skill with pre-push safety checks
  Files:     3 changed (+156, -12)
  Remote:    origin/feature/add-push-skill

  Checks:
  ✓ Branch safety
  ✓ Secret scan
  ✓ Debug statements
  ✓ Lint
  ✓ Tests (14 passed)

══════════════════════════════════════
```

### Blocked
```
══════════════════════════════════════
  Push Blocked
══════════════════════════════════════

  ✓ Branch safety
  ✗ Secret scan — API key found in src/config.ts:12
  - Debug statements (skipped — blocked before)
  - Lint (skipped)
  - Tests (skipped)

  Fix: Remove the hardcoded API key and use environment variables.
══════════════════════════════════════
```

---

## Flag Behavior

### `/push --force`
```
⚠️  Force mode: tüm kontroller atlanacak.

Değişiklikler:
  M src/auth.ts
  M src/utils.ts
  A src/new-feature.ts

Kontrolsüz push yapmak istediğine emin misin? (Y/N)
```

### `/push --amend`
```
⚠️  Son commit düzenlenecek ve force-push yapılacak.

Son commit: a1b2c3d feat: add login feature
Bu commit'i değiştirmek istediğine emin misin? (Y/N)

Not: Başkalarıyla paylaşılan branch'lerde --amend tehlikeli olabilir.
```

---

## Examples

```
/push
/push check
/push --force
/push --amend
```

---

## Key Principles

- **Safety first** — secrets and broken tests never reach remote
- **Smart defaults** — auto-detect linter, test runner, change type
- **User control** — always show what will happen, ask before acting
- **Conventional Commits** — consistent, machine-readable commit history
- **No silent failures** — every check reports its result
