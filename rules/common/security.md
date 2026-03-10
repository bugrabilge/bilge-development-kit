# Security Rules

> Always-on security requirements. Applied to all code output.

---

## Secrets Management

**NEVER hardcode secrets.** No exceptions.

| DO | DON'T |
|----|-------|
| `process.env.API_KEY` | `const API_KEY = "sk-abc123..."` |
| `.env` file (gitignored) | Secrets in source code |
| Secrets manager (Vault, AWS SM) | Secrets in config files |
| `.env.example` with placeholders | Real values in examples |

### Files That Must Be Gitignored

```gitignore
.env
.env.local
.env.production
*.key
*.pem
*.p12
credentials.json
service-account.json
```

---

## Input Validation (Trust Boundaries)

**Validate ALL external input. Trust nothing from outside the system.**

| Source | Action |
|--------|--------|
| User forms | Sanitize + validate type/length/format |
| URL parameters | Validate, decode safely |
| API request bodies | Schema validation (Zod, Pydantic, Joi) |
| File uploads | Validate type, size, scan content |
| Database results | Type-check before use (defense in depth) |

---

## Common Vulnerabilities (OWASP Top 10)

| Vulnerability | Prevention |
|--------------|-----------|
| **SQL Injection** | Parameterized queries ALWAYS. Never string concatenation. |
| **XSS** | Encode output. Use framework auto-escaping. CSP headers. |
| **CSRF** | CSRF tokens for state-changing requests. SameSite cookies. |
| **Broken Auth** | bcrypt/argon2 for passwords. Rate limit login. Session timeout. |
| **Sensitive Data Exposure** | HTTPS everywhere. Encrypt at rest. Mask in logs. |
| **Mass Assignment** | Whitelist allowed fields. Never pass raw request to ORM. |
| **SSRF** | Validate URLs. Block internal IPs. Allowlist domains. |

---

## Dependency Security

- Run `npm audit` / `pip audit` / `cargo audit` before every deploy
- Keep dependencies updated (Dependabot/Renovate)
- Review new dependencies: check downloads, maintainers, last update
- Pin versions in production (`package-lock.json` committed)
- Avoid packages with < 1000 weekly downloads unless justified

---

## Authentication & Authorization

- Hash passwords with bcrypt (cost 12+) or argon2
- Use established auth libraries (don't roll your own crypto)
- Implement proper session management (httpOnly, secure, SameSite)
- Rate limit auth endpoints (5 attempts per minute)
- Log auth events (login, logout, failed attempts)
