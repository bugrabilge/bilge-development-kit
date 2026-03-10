# Testing Rules

> Always-on testing requirements. Applied when writing or modifying code.

---

## When Tests Are Required

| Change Type | Test Required? |
|-------------|---------------|
| New feature | YES - unit + integration |
| Bug fix | YES - regression test proving fix |
| Refactor | YES - existing tests must pass |
| Config/docs only | NO |
| Prototype/spike | NO (but mark as untested) |

---

## Test Structure: AAA Pattern

```
Arrange  →  Set up test data and preconditions
Act      →  Execute the function/action under test
Assert   →  Verify the expected outcome
```

One assertion group per test. Multiple related asserts OK, unrelated asserts = separate test.

---

## Naming Convention

Format: `should_[expected behavior]_when_[condition]`

```python
# Python
def test_should_return_404_when_user_not_found():
def test_should_hash_password_when_creating_user():

# JavaScript
it('should return 404 when user not found', () => {})
it('should hash password when creating user', () => {})
```

---

## Coverage Targets

| Level | Target | Focus |
|-------|--------|-------|
| Unit | 80% | Business logic, utilities, pure functions |
| Integration | 60% | API endpoints, database queries, service interactions |
| E2E | Critical paths | Auth flow, checkout, core user journeys |

Coverage is a guide, not a goal. 80% meaningful > 100% trivial.

---

## Test Pyramid

```
    /  E2E  \        Few, slow, expensive
   / Integration \    Moderate amount
  /    Unit Tests  \  Many, fast, cheap
```

**Ratio guideline:** 70% unit, 20% integration, 10% E2E

---

## Anti-Patterns (Avoid)

- Testing implementation details instead of behavior
- Tests that depend on execution order
- Mocking everything (test real behavior when feasible)
- Ignoring flaky tests (fix or delete them)
- Testing framework/library internals
