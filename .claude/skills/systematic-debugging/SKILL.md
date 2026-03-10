---
user-invocable: false
name: systematic-debugging
description: Comprehensive debugging methodology covering systematic 4-phase process, hypothesis-driven strategies, observability tools, profiling, and production-safe techniques. Use when debugging complex issues, performance problems, or production incidents.
allowed-tools: Read, Glob, Grep
---

# Systematic Debugging

> Source: obra/superpowers (enhanced with debugging-strategies and debugging-toolkit content)

## Overview
This skill provides a structured approach to debugging that prevents random guessing and ensures problems are properly understood before solving. Covers everything from local debugging to production incident investigation.

## Use this skill when

- Tracking down elusive bugs
- Investigating performance issues
- Debugging production incidents
- Analyzing crash dumps or stack traces
- Debugging distributed systems

## Do not use this skill when

- There is no reproducible issue or observable symptom
- The task is purely feature development
- You cannot access logs, traces, or runtime signals

## 4-Phase Debugging Process

### Phase 1: Reproduce
Before fixing, reliably reproduce the issue.

```markdown
## Reproduction Steps
1. [Exact step to reproduce]
2. [Next step]
3. [Expected vs actual result]

## Reproduction Rate
- [ ] Always (100%)
- [ ] Often (50-90%)
- [ ] Sometimes (10-50%)
- [ ] Rare (<10%)
```

### Phase 2: Isolate
Narrow down the source.

```markdown
## Isolation Questions
- When did this start happening?
- What changed recently?
- Does it happen in all environments?
- Can we reproduce with minimal code?
- What's the smallest change that triggers it?
```

### Phase 3: Understand
Find the root cause, not just symptoms.

```markdown
## Root Cause Analysis
### The 5 Whys
1. Why: [First observation]
2. Why: [Deeper reason]
3. Why: [Still deeper]
4. Why: [Getting closer]
5. Why: [Root cause]
```

### Phase 4: Fix & Verify
Fix and verify it's truly fixed.

```markdown
## Fix Verification
- [ ] Bug no longer reproduces
- [ ] Related functionality still works
- [ ] No new issues introduced
- [ ] Test added to prevent regression
```

## Hypothesis-Driven Debugging

For each hypothesis include:
- Probability score (0-100%)
- Supporting evidence from logs/traces/code
- Falsification criteria
- Testing approach
- Expected symptoms if true

### Common Bug Categories
- **Logic errors**: Race conditions, null handling, off-by-one
- **State management**: Stale cache, incorrect transitions
- **Integration failures**: API changes, timeouts, auth issues
- **Resource exhaustion**: Memory leaks, connection pools
- **Configuration drift**: Env vars, feature flags
- **Data corruption**: Schema mismatches, encoding issues

## Strategy Selection

Select debugging strategy based on issue characteristics:

- **Interactive Debugging**: Reproducible locally -- use VS Code/Chrome DevTools, step-through
- **Observability-Driven**: Production issues -- use Sentry/DataDog/Honeycomb, trace analysis
- **Time-Travel**: Complex state issues -- use rr/Redux DevTools, record and replay
- **Binary Search**: Git bisect for regressions, comment-out-half for code isolation
- **Differential**: Compare working vs broken environments, configs, data
- **Statistical**: Small % of cases -- delta debugging, compare success vs failure

## Observability Data Collection

For production/staging issues, gather data from:
- **Error tracking**: Sentry, Rollbar, Bugsnag
- **APM metrics**: DataDog, New Relic, Dynatrace
- **Distributed traces**: Jaeger, Zipkin, Honeycomb
- **Log aggregation**: ELK, Splunk, Loki
- **Session replays**: LogRocket, FullStory

Query for: error frequency/trends, affected user cohorts, environment-specific patterns, performance degradation correlation, deployment timeline correlation.

## Production-Safe Techniques

- **Dynamic Instrumentation**: OpenTelemetry spans, non-invasive attributes
- **Feature-Flagged Debug Logging**: Conditional logging for specific users
- **Sampling-Based Profiling**: Continuous profiling with minimal overhead (Pyroscope)
- **Read-Only Debug Endpoints**: Protected by auth, rate-limited state inspection
- **Gradual Traffic Shifting**: Canary deploy debug version to small % of traffic

## Debugging Checklist

```markdown
## Before Starting
- [ ] Can reproduce consistently
- [ ] Have minimal reproduction case
- [ ] Understand expected behavior
- [ ] Parsed error messages/stack traces
- [ ] Identified affected components/services

## During Investigation
- [ ] Check recent changes (git log)
- [ ] Check logs for errors
- [ ] Add logging if needed
- [ ] Use debugger/breakpoints
- [ ] Generate ranked hypotheses
- [ ] Test hypotheses systematically

## After Fix
- [ ] Root cause documented
- [ ] Fix verified
- [ ] Regression test added
- [ ] Similar code checked
- [ ] No performance regression
- [ ] Monitoring/alerts added for similar issues
```

## Common Debugging Commands

```bash
# Recent changes
git log --oneline -20
git diff HEAD~5

# Git bisect for finding regression
git bisect start
git bisect bad                    # Current commit is bad
git bisect good v1.0.0            # Known good version
# Test middle commit, then: git bisect good/bad
git bisect reset                  # When done

# Search for pattern
grep -r "errorPattern" --include="*.ts"

# Check logs
pm2 logs app-name --err --lines 100
```

## Debugging Patterns by Issue Type

### Intermittent Bugs
1. Add extensive logging (timing, state transitions, external interactions)
2. Look for race conditions (concurrent access, async ordering, missing sync)
3. Check timing dependencies (setTimeout, Promise resolution order)
4. Stress test (run many times, vary timing, simulate load)

### Performance Issues
1. Profile first -- don't optimize blindly
2. Common culprits: N+1 queries, unnecessary re-renders, large data processing, synchronous I/O
3. Tools: Browser DevTools Performance tab, Lighthouse, cProfile/line_profiler (Python), clinic.js/0x (Node)

### Production Bugs
1. Gather evidence from error tracking, logs, user reports, metrics
2. Reproduce locally with production data (anonymized) and matched environment
3. Safe investigation: don't change production, use feature flags, test fixes in staging

## Output Format

When reporting debugging results, provide:
1. **Issue Summary**: Error, frequency, impact
2. **Root Cause**: Detailed diagnosis with evidence
3. **Fix Proposal**: Code changes, risk, impact
4. **Validation Plan**: Steps to verify fix
5. **Prevention**: Tests, monitoring, documentation

## Anti-Patterns

- **Random changes** - "Maybe if I change this..."
- **Ignoring evidence** - "That can't be the cause"
- **Assuming** - "It must be X" without proof
- **Not reproducing first** - Fixing blindly
- **Stopping at symptoms** - Not finding root cause
- **Making multiple changes at once** - Change one thing at a time
- **Not reading error messages** - Read the full stack trace
- **Debug logging in prod** - Remove before shipping
