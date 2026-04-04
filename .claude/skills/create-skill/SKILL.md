---
name: create-skill
description: >
  Generate a new custom skill from natural language description.
  Use when: "create skill", "new skill", "make a skill", "add command",
  "custom workflow", "skill template", "generate skill"
argument-hint: "<skill name and description>"
user-invocable: true
---

# /create-skill - Skill Generator

$ARGUMENTS

---

## Purpose

Generate a new Claude Code skill (slash command) from a natural language description. Creates properly structured SKILL.md with frontmatter, behavior rules, and output format.

---

## Behavior

When `/create-skill` is triggered:

### Step 1: Parse Input

Extract from user's description:
- **Skill name**: lowercase, hyphenated (e.g., `api-test`, `changelog`)
- **Purpose**: what the skill does
- **Trigger terms**: when should it activate

If input is vague, ask:
1. What should this skill do?
2. Does it modify code or only analyze/report?
3. What sub-commands should it have?

### Step 2: Determine Skill Type

| Type | Characteristics | `disable-model-invocation` |
|------|----------------|---------------------------|
| **Analysis** | Read-only, generates reports | `true` |
| **Generator** | Creates new files/code | `true` |
| **Interactive** | Asks questions, explores options | `false` |
| **Automation** | Runs scripts, orchestrates agents | `true` |

### Step 3: Generate SKILL.md

Create `.claude/skills/{name}/SKILL.md` with this structure:

```markdown
---
name: {skill-name}
description: >
  {One-line purpose}.
  Use when: {comma-separated trigger terms}
argument-hint: "{expected arguments}"
user-invocable: true
disable-model-invocation: {true|false}
---

# /{skill-name} - {Title}

$ARGUMENTS

---

## Purpose

{What this skill does and why it exists.}

---

## Sub-commands

{If applicable}

---

## Behavior

When `/{skill-name}` is triggered:

### 1. {First Step}
{Description}

### 2. {Second Step}
{Description}

### 3. {Third Step}
{Description}

---

## Output Format

{Expected output template}

---

## Examples

{Usage examples}

---

## Key Principles

- {Principle 1}
- {Principle 2}
- {Principle 3}
```

### Step 4: Validate

Check generated skill:
- [ ] Name is lowercase, hyphenated, max 30 chars
- [ ] Description fits in 250 chars (budget limit)
- [ ] Has clear trigger terms in description
- [ ] `$ARGUMENTS` placeholder is present
- [ ] No unsupported frontmatter fields
- [ ] Output format is defined

### Step 5: Report

```
Skill created: .claude/skills/{name}/SKILL.md

Test it:
  /{name} {example args}

To customize:
  Edit .claude/skills/{name}/SKILL.md
```

---

## Supported Frontmatter Fields

Only use these (others are ignored by Claude Code):

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Skill identifier |
| `description` | Yes | What it does + trigger terms (max 250 chars) |
| `user-invocable` | Yes | Must be `true` for slash commands |
| `argument-hint` | No | Shows in slash menu |
| `disable-model-invocation` | No | Prevent auto-triggering |
| `compatibility` | No | Platform compatibility notes |
| `license` | No | License info |
| `metadata` | No | Additional metadata |

---

## Examples

```
/create-skill changelog generator that creates CHANGELOG.md from git history
/create-skill api-test automated API endpoint testing with curl
/create-skill docs-gen generate documentation from code comments
/create-skill perf-check performance analysis with lighthouse scores
/create-skill i18n extract translatable strings and manage translations
```

---

## Key Principles

- **Convention over configuration** — sensible defaults, customize later
- **Budget-aware** — descriptions under 250 chars
- **Consistent structure** — all skills follow same template
- **Test immediately** — user should try the skill right after creation
