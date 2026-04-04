---
name: refactor
description: >
  Safe, systematic code refactoring with test safety net.
  Use when: "refactor", "clean up", "simplify", "modernize",
  "extract", "rename across", "reduce complexity", "tech debt"
argument-hint: "<file/dir|analyze|extract|rename|modernize|types>"
user-invocable: true
disable-model-invocation: true
---

# /refactor - Systematic Refactoring

$ARGUMENTS

---

## Purpose

This command performs safe, systematic refactoring using the `code-archaeologist` agent with support from domain specialists.

---

## Sub-commands

```
/refactor [file/dir]     - Analyze and refactor target
/refactor analyze        - Analysis only, no changes
/refactor extract        - Extract functions/components
/refactor rename         - Rename across codebase
/refactor modernize      - Update to modern patterns
/refactor types          - Add/improve TypeScript types
```

---

## Behavior

When `/refactor` is triggered:

### Phase 1: Analysis (NO CODE CHANGES)

1. **Invoke `code-archaeologist` agent**
   - Map the code structure
   - Identify anti-patterns and tech debt
   - Assess risk of changes
   - Find dependencies that will be affected

2. **Invoke `explorer-agent`** (if needed)
   - Trace usage across codebase
   - Find all consumers/dependents

3. **Present analysis to user**
   ```markdown
   ## Refactoring Analysis: [Target]

   ### Current State
   - Complexity: [Low/Medium/High]
   - Test Coverage: [X%]
   - Dependencies: [List of affected files]

   ### Proposed Changes
   1. [Change with rationale]
   2. [Change with rationale]

   ### Risk Assessment
   | Risk | Mitigation |
   |------|------------|
   | [Risk] | [How to mitigate] |

   ### Estimated Impact
   - Files changed: X
   - Lines modified: ~Y

   Proceed? (Y/N)
   ```

### Phase 2: Safety Net (After Approval)

1. **Invoke `test-engineer`**
   - Write characterization tests (capture current behavior)
   - Verify tests pass on current code
   - These tests protect against regression

### Phase 3: Refactor (Sequential, Verified)

1. **Apply changes incrementally**
   - One refactoring at a time
   - Run tests after each change
   - If tests fail, revert and investigate

2. **Common refactoring operations:**

   | Operation | When to Use |
   |-----------|-------------|
   | Extract function/method | Long functions (>30 lines) |
   | Extract component | Component does too many things |
   | Rename | Unclear or misleading names |
   | Move/reorganize | Wrong file location |
   | Simplify conditionals | Nested if/else pyramids |
   | Replace patterns | Class -> Hook, Callback -> Promise |
   | Add types | `any` types, missing interfaces |

### Phase 4: Verify

1. Run all tests
2. Run lint check
3. Verify no regressions
4. Present diff summary

---

## Output Format

```markdown
## Refactoring Report: [Target]

### Changes Made
1. [File:Lines] - [What changed and why]
2. [File:Lines] - [What changed and why]

### Before/After Metrics
| Metric | Before | After |
|--------|--------|-------|
| Cyclomatic complexity | X | Y |
| Lines of code | X | Y |
| Type coverage | X% | Y% |

### Tests
- Characterization tests: X added
- All tests: PASSING

### Files Modified
- [list of files]
```

---

## Safety Rules

1. **NEVER refactor without tests** - Write characterization tests first
2. **One change at a time** - Don't combine multiple refactorings
3. **Verify after each step** - Run tests between changes
4. **Preserve behavior** - Refactoring changes structure, NOT behavior
5. **Get approval for risky changes** - Breaking API changes need user OK

---

## Examples

```
/refactor src/services/auth.ts
/refactor analyze src/components/Dashboard/
/refactor modernize src/utils/legacy-helpers.js
/refactor types src/api/
/refactor extract src/pages/HomePage.tsx
```

---

## Key Principles

- **Understand before changing** - Chesterton's Fence applies
- **Small steps** - Incremental is safer than big-bang
- **Tests are your safety net** - No tests = no refactoring
- **Communicate risk** - Be transparent about what could break
