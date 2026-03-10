---
name: red-team-tactics
description: "Offensive security, penetration testing methodology, OWASP testing guide, exploitation techniques, and professional reporting."
---

# Red Team Tactics

> "To know your enemy, you must become your enemy." -- Sun Tzu

## When to Use
- Planning and executing penetration tests against web applications
- Following OWASP Testing Guide methodology
- Identifying and exploiting security weaknesses in applications
- Performing reconnaissance and attack surface mapping
- Writing professional penetration test reports
- Understanding attacker mindset to improve defensive security
- Simulating real-world attack scenarios

## Penetration Testing Methodology

### Phases of Engagement
1. **Scoping:** Define targets, rules of engagement, and boundaries
2. **Reconnaissance:** Gather intelligence about the target
3. **Enumeration:** Map the attack surface in detail
4. **Vulnerability Analysis:** Identify potential weaknesses
5. **Exploitation:** Attempt to exploit discovered vulnerabilities
6. **Post-Exploitation:** Assess the impact of successful exploitation
7. **Reporting:** Document findings with evidence and remediation guidance

### Rules of Engagement
- Always have written authorization before testing
- Define in-scope and out-of-scope systems explicitly
- Agree on testing windows and communication procedures
- Establish emergency contacts and stop conditions
- Document any production impact risks and obtain acknowledgment
- Never access, modify, or exfiltrate real user data

## Reconnaissance

### Passive Reconnaissance (OSINT)
No direct interaction with the target:
- **Domain enumeration:** WHOIS, DNS records, certificate transparency logs
- **Subdomain discovery:** crt.sh, SecurityTrails, Amass passive mode
- **Technology fingerprinting:** Wappalyzer, BuiltWith, HTTP headers
- **Code exposure:** GitHub/GitLab search for organization repos, leaked credentials
- **Employee enumeration:** LinkedIn, job postings reveal tech stack
- **Archived pages:** Wayback Machine for old endpoints and configurations
- **Google dorking:** `site:target.com filetype:pdf`, `inurl:admin`, `intitle:"index of"`

### Active Reconnaissance
Direct interaction with target systems:
- **Port scanning:** Nmap for service discovery and version detection
- **Web spidering:** Crawl the application to map all pages and forms
- **Directory brute-forcing:** ffuf, feroxbuster, gobuster for hidden paths
- **API discovery:** Check /swagger, /api-docs, /graphql, /.well-known/
- **Technology profiling:** HTTP response headers, error messages, cookies

## OWASP Testing Guide

### A01: Broken Access Control
- Test for IDOR: Change IDs in URLs, request bodies, and headers
- Verify horizontal privilege escalation (user A accessing user B's data)
- Test vertical privilege escalation (regular user accessing admin functions)
- Check for missing function-level access control (direct API access)
- Test JWT manipulation: algorithm confusion, signature stripping, claim modification
- Verify CORS policy: Can unauthorized origins make credentialed requests?

### A02: Cryptographic Failures
- Check for data transmitted over HTTP (not HTTPS)
- Identify weak TLS configurations (SSLyze, testssl.sh)
- Look for sensitive data in URLs (tokens, passwords in query strings)
- Check for weak hashing algorithms (MD5, SHA1 for passwords)
- Verify encryption at rest for sensitive data stores

### A03: Injection
- **SQL Injection:** Test all input fields with `'`, `"`, `1 OR 1=1`, UNION-based, blind (time-based)
- **NoSQL Injection:** Test with `{"$gt":""}`, `{"$ne":""}` in JSON bodies
- **Command Injection:** Test with `; ls`, `| whoami`, `$(id)`, backticks
- **LDAP Injection:** Test with `*`, `)(`, `*)(objectClass=*)`
- **Template Injection (SSTI):** Test with `{{7*7}}`, `${7*7}`, `<%= 7*7 %>`
- Use automated tools (SQLMap) for confirmation, but test manually first

### A04: Insecure Design
- Analyze business logic for abuse scenarios
- Test rate limiting on sensitive endpoints (login, password reset, OTP)
- Check for race conditions in financial transactions
- Verify that security questions aren't bypassable
- Test multi-step processes for step-skipping

### A05: Security Misconfiguration
- Check for default credentials on admin panels
- Look for verbose error messages exposing stack traces
- Verify that directory listings are disabled
- Check for unnecessary HTTP methods (PUT, DELETE, TRACE)
- Test for exposed admin interfaces, debug endpoints, phpinfo()
- Review CORS, CSP, and other security headers

### A06: Vulnerable Components
- Identify all third-party components and their versions
- Cross-reference with CVE databases and known exploits
- Check for outdated JavaScript libraries (retire.js)
- Test for known exploits against identified component versions

### A07: Authentication Failures
- Test for credential stuffing (no rate limiting or CAPTCHA)
- Check password policy (minimum length, complexity, breached password check)
- Test account lockout mechanism and bypass
- Verify multi-factor authentication implementation
- Test "remember me" token security
- Check session fixation and session ID randomness
- Test password reset flow for token predictability and expiration

### A08: Data Integrity Failures
- Test for insecure deserialization
- Check for unsigned cookies or JWTs
- Verify integrity of software update mechanisms
- Test CI/CD pipeline security

### A09: Logging and Monitoring Failures
- Verify that security events are logged (failed logins, access denied)
- Check that logs don't contain sensitive data (passwords, tokens)
- Test if log injection is possible (injecting fake log entries)

### A10: Server-Side Request Forgery (SSRF)
- Test URL parameters that fetch remote resources
- Try internal addresses: `127.0.0.1`, `169.254.169.254` (cloud metadata), `localhost`
- Test URL scheme bypass: `file://`, `gopher://`, `dict://`
- Check for DNS rebinding possibilities
- Test redirect-based SSRF (open redirect chained with SSRF)

## Exploitation Techniques

### Web Application Exploitation
- **XSS payloads:** Start simple (`<script>alert(1)</script>`), escalate to cookie theft, keylogging
- **CSRF:** Craft forms that perform state-changing actions on behalf of authenticated users
- **File upload bypass:** Change extensions, MIME types, magic bytes, use double extensions
- **Authentication bypass:** Default creds, SQL injection in login, JWT manipulation
- **Path traversal:** `../../../etc/passwd`, null byte injection, URL encoding bypass

### API-Specific Testing
- Test all CRUD operations with different authorization levels
- Check for mass assignment (send extra fields that shouldn't be writable)
- Test GraphQL introspection, batching attacks, nested query DoS
- Verify rate limiting on API endpoints
- Test for information disclosure in error responses
- Check API versioning for deprecated (less secure) endpoints

### Token and Session Attacks
- Analyze session tokens for predictability and entropy
- Test token reuse after logout (session invalidation)
- Check for token leakage in logs, referrer headers, or URL parameters
- Test JWT: remove signature (alg: none), change algorithm (RS256 to HS256), brute-force weak secrets

## Post-Exploitation Assessment

### Impact Demonstration
- Document what data is accessible with the exploited access
- Show lateral movement possibilities (what else can be reached)
- Demonstrate privilege escalation paths
- Quantify the blast radius of each vulnerability
- Chain vulnerabilities to show realistic attack scenarios
- Take screenshots and save evidence at every step

### Responsible Practices
- Never exfiltrate real personal or sensitive data
- Use proof-of-concept payloads that demonstrate impact without harm
- Stop exploitation when impact is clearly demonstrated
- Report critical findings immediately (don't wait for final report)
- Clean up any artifacts (test accounts, uploaded files, modified data)

## Reporting

### Report Structure
1. **Executive Summary:** Non-technical overview of risk posture and key findings
2. **Scope and Methodology:** What was tested, how, and when
3. **Findings Summary:** Table of all findings with severity ratings
4. **Detailed Findings:** Each finding with description, evidence, impact, and remediation
5. **Positive Observations:** Security controls that were effective
6. **Recommendations:** Prioritized remediation roadmap

### Finding Documentation
Each finding should include:
- **Title:** Clear, descriptive vulnerability name
- **Severity:** Critical / High / Medium / Low / Informational (with CVSS if applicable)
- **Description:** What the vulnerability is and where it exists
- **Evidence:** Screenshots, request/response pairs, proof-of-concept steps
- **Impact:** What an attacker could achieve by exploiting this
- **Remediation:** Specific, actionable fix with code examples where possible
- **References:** CWE, OWASP, CVE references

### Severity Rating Guidelines
- **Critical:** Remote code execution, authentication bypass, mass data exposure
- **High:** Privilege escalation, stored XSS, SQL injection, SSRF to internal services
- **Medium:** CSRF, reflected XSS, information disclosure, missing security headers
- **Low:** Verbose errors, minor information leakage, outdated (but unaffected) components
- **Informational:** Best practice recommendations, defense-in-depth suggestions
