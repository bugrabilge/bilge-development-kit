---
name: security
description: >
  Comprehensive security audit with OWASP Top 10 analysis.
  Use when: "security", "vulnerability", "audit", "pentest",
  "check secrets", "is it secure", "owasp", "security scan"
argument-hint: "[quick|auth|deps|owasp]"
user-invocable: true
disable-model-invocation: true
---

# /security - Security Audit

$ARGUMENTS

---

## Purpose

This command performs a comprehensive security audit on the project using `security-auditor` and `penetration-tester` agents.

---

## Sub-commands

```
/security              - Full security audit
/security quick        - Quick scan (secrets + dependencies only)
/security auth         - Authentication/authorization review
/security deps         - Dependency vulnerability scan
/security owasp        - OWASP Top 10 checklist review
```

---

## Behavior

When `/security` is triggered:

1. **Automated scans**
   ```bash
   # Run security scan script
   python .agent/skills/vulnerability-scanner/scripts/security_scan.py .

   # Run dependency analysis
   python .agent/skills/vulnerability-scanner/scripts/dependency_analyzer.py .

   # Check for secrets in code
   # (included in security_scan.py)
   ```

2. **Agent analysis**
   - Invoke `security-auditor` agent for code review
   - Invoke `penetration-tester` agent for attack surface analysis

3. **OWASP Top 10:2025 checklist**

   | # | Category | Check |
   |---|----------|-------|
   | A01 | Broken Access Control | IDOR, auth bypass, SSRF |
   | A02 | Security Misconfiguration | Headers, CORS, defaults |
   | A03 | Supply Chain | Dependencies, lock files |
   | A04 | Cryptographic Failures | Weak crypto, exposed secrets |
   | A05 | Injection | SQL, XSS, command injection |
   | A06 | Insecure Design | Architecture flaws |
   | A07 | Auth Failures | Session, MFA, credentials |
   | A08 | Integrity Failures | Unsigned updates |
   | A09 | Logging Failures | Missing audit trails |
   | A10 | Exceptional Conditions | Error handling, fail-open |

4. **Generate report**

---

## Output Format

```markdown
## Security Audit Report

### Scan Results
- Security Scan: PASS/FAIL
- Dependency Audit: X vulnerabilities (Y critical)
- Secrets Check: PASS/FAIL

### Findings by OWASP Category

#### A01: Broken Access Control
- [Finding or "No issues found"]

#### A05: Injection
- [Finding or "No issues found"]

[... all categories ...]

### Risk Summary
| Severity | Count | Action |
|----------|-------|--------|
| Critical | X | Fix immediately |
| High     | X | Fix before deploy |
| Medium   | X | Schedule fix |
| Low      | X | Document |

### Recommendations
1. [Priority fix with details]
2. [Secondary fix]

### Next Steps
- [ ] Fix critical findings
- [ ] Re-run `/security quick` to verify
- [ ] Schedule medium/low fixes
```

---

## Examples

```
/security
/security quick
/security auth
/security deps
/security owasp
```

---

## Key Principles

- **Assume breach** - Design as if attacker is already inside
- **Zero trust** - Never trust, always verify
- **Defense in depth** - Multiple layers, no single point of failure
- **Evidence-based** - Every finding needs proof
- **Prioritize by risk** - Critical first, not alphabetical
