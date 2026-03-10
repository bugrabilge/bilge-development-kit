# Code Review Mode Context

> Active when reviewing code, pull requests, or conducting quality assessments.

---

## Review Checklist

### Functionality
- [ ] Does the code do what it claims?
- [ ] Are edge cases handled?
- [ ] Are error states handled gracefully?

### Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on trust boundaries
- [ ] SQL injection / XSS / CSRF prevention
- [ ] Proper authentication/authorization checks

### Performance
- [ ] No N+1 queries
- [ ] No unbounded data fetches
- [ ] Expensive operations cached or optimized
- [ ] No memory leaks (event listeners, subscriptions)

### Code Quality
- [ ] Follows project naming conventions
- [ ] Single responsibility per function/class
- [ ] No dead code or commented-out blocks
- [ ] DRY: no unnecessary repetition (3+ = extract)

### Testing
- [ ] New code has corresponding tests
- [ ] Bug fixes include regression tests
- [ ] Tests follow AAA pattern
- [ ] No flaky or order-dependent tests

### Breaking Changes
- [ ] API contract changes documented
- [ ] Database migrations reversible
- [ ] Backward compatibility maintained (or documented)

## Review Response Format

```markdown
### Summary
[1-2 sentence overview of changes]

### Approved / Changes Requested / Blocked

### Findings
- **[CRITICAL]** [Must fix before merge]
- **[SUGGESTION]** [Would improve but not blocking]
- **[QUESTION]** [Need clarification]
- **[PRAISE]** [Well done, good pattern]
```

## Severity Levels

| Level | Action | Examples |
|-------|--------|---------|
| **CRITICAL** | Must fix | Security flaw, data loss risk, broken feature |
| **MAJOR** | Should fix | Performance issue, poor error handling |
| **MINOR** | Nice to fix | Naming, style, minor optimization |
| **NIT** | Optional | Preference, cosmetic |
