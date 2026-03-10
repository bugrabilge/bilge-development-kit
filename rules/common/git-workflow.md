# Git Workflow Rules

> Always-on rules for git operations. Applied automatically to all code tasks.

---

## Commit Messages

Format: `type(scope): description`

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `refactor` - Code restructuring (no behavior change)
- `docs` - Documentation only
- `test` - Adding/updating tests
- `chore` - Build, CI, tooling
- `perf` - Performance improvement
- `style` - Formatting (no logic change)

**Rules:**
- Subject line: max 72 characters, imperative mood ("Add" not "Added")
- No period at end of subject
- Body: explain WHY, not WHAT (the diff shows what)
- Reference issue/ticket if applicable: `Closes #123`

**Examples:**
```
feat(auth): add OAuth2 login with Google provider
fix(cart): prevent negative quantity on item update
refactor(api): extract validation middleware from controllers
```

---

## Branch Naming

Format: `type/short-description`

| Type | Usage |
|------|-------|
| `feature/` | New features |
| `fix/` | Bug fixes |
| `hotfix/` | Urgent production fixes |
| `refactor/` | Code restructuring |
| `docs/` | Documentation updates |
| `test/` | Test additions |

**Rules:**
- Lowercase, hyphen-separated: `feature/user-auth`
- Max 50 characters
- No special characters except `-` and `/`

---

## Pull Requests

- Title: `<type>: <short description>` (max 70 chars)
- Body must include: Summary (what + why), Test Plan
- One PR = one concern (don't mix features)
- Squash merge preferred for clean history

---

## General Rules

- Never commit directly to `main`/`master` in team projects
- Commit often, push regularly
- Don't commit generated files (build/, dist/, node_modules/)
- Use `.gitignore` proactively
- Rebase feature branches on main before merging (when working solo)
