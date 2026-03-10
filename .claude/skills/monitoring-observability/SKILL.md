---
user-invocable: false
name: monitoring-observability
description: "Comprehensive production monitoring, logging, tracing, alerting, SLI/SLO management, and observability patterns. Covers structured logging, distributed tracing, metrics collection, incident alerting, chaos engineering, and observability-as-code."
---

# Monitoring & Observability Skill

Patterns and best practices for making production systems observable and debuggable.

## Three Pillars of Observability

| Pillar | Purpose | Tools |
|--------|---------|-------|
| **Logs** | What happened (events) | Pino, Winston, Python logging |
| **Metrics** | How much/how fast (numbers) | Prometheus, Datadog, CloudWatch |
| **Traces** | Request flow across services | OpenTelemetry, Jaeger, Zipkin |

---

## Structured Logging

### Principles

| Principle | Rule |
|-----------|------|
| **Always structured** | JSON format, never plain text in production |
| **Always contextual** | Include requestId, userId, service name |
| **Never sensitive** | No passwords, tokens, PII in logs |
| **Appropriate levels** | ERROR=broken, WARN=degraded, INFO=business events, DEBUG=dev only |

### Log Levels

| Level | When to Use | Example |
|-------|-------------|---------|
| **ERROR** | Something is broken, needs attention | DB connection failed, unhandled exception |
| **WARN** | Degraded but functional | Retry succeeded, cache miss, slow query |
| **INFO** | Business-significant events | User registered, order placed, deploy complete |
| **DEBUG** | Development troubleshooting | Function input/output, state changes |

### What to Log

| Always Log | Never Log |
|------------|-----------|
| Request start/end with duration | Passwords or tokens |
| Error with stack trace | Full credit card numbers |
| Business events (signup, purchase) | PII without anonymization |
| External API calls with latency | Health check successes (too noisy) |
| Deployment events | Debug logs in production |

### Structured Log Format

```json
{
  "timestamp": "2025-03-05T10:30:00.000Z",
  "level": "error",
  "service": "api",
  "requestId": "req_abc123",
  "userId": "usr_456",
  "message": "Payment processing failed",
  "error": {
    "name": "PaymentError",
    "message": "Card declined",
    "code": "CARD_DECLINED"
  },
  "duration_ms": 1250,
  "metadata": {
    "provider": "stripe",
    "amount": 9900
  }
}
```

---

## Metrics

### Key Metrics (RED Method for Services)

| Metric | What | Alert When |
|--------|------|------------|
| **Rate** | Requests per second | Sudden drop (outage) or spike (attack) |
| **Errors** | Error rate (%) | > 1% of requests |
| **Duration** | Latency (P50, P95, P99) | P95 > 2x normal |

### Key Metrics (USE Method for Resources)

| Metric | What | Alert When |
|--------|------|------------|
| **Utilization** | % resource in use | CPU > 80%, Memory > 85%, Disk > 90% |
| **Saturation** | Queue depth, waiting | Queue growing, not draining |
| **Errors** | Resource errors | Disk I/O errors, OOM kills |

### Business Metrics

| Metric | Purpose |
|--------|---------|
| Signups per hour | Growth monitoring |
| Conversion rate | Business health |
| Revenue per minute | Revenue monitoring |
| Active users | Engagement tracking |

---

## Alerting

### Alert Design Principles

| Principle | Rule |
|-----------|------|
| **Actionable** | Every alert must have a runbook or clear action |
| **No noise** | If you ignore it, it shouldn't be an alert |
| **Tiered severity** | Page for critical, Slack for warning, email for info |
| **Include context** | Alert must contain enough info to start investigating |

### Alert Severity

| Severity | Channel | Response Time | Example |
|----------|---------|---------------|---------|
| **Critical** | PagerDuty / Phone | < 5 min | Service down, data loss risk |
| **High** | Slack #alerts | < 30 min | Error rate > 5%, high latency |
| **Warning** | Slack #monitoring | < 4 hours | Disk 80%, slow queries |
| **Info** | Dashboard only | Next business day | Deployment complete |

### Anti-patterns

| Anti-Pattern | Problem |
|-------------|---------|
| Alert on every error | Alert fatigue, people ignore |
| No runbook | Responder doesn't know what to do |
| Alert on symptom only | Need to understand cause |
| Static thresholds only | Misses anomalies, triggers on normal variation |

---

## Health Checks

### Types

| Type | Purpose | Frequency |
|------|---------|-----------|
| **Liveness** | "Is the process running?" | Every 10s |
| **Readiness** | "Can it serve traffic?" | Every 5s |
| **Startup** | "Has it finished initializing?" | During boot |
| **Deep health** | "Are all dependencies OK?" | Every 30s |

### Health Check Response

```json
{
  "status": "healthy",
  "version": "1.2.3",
  "uptime_seconds": 86400,
  "checks": {
    "database": { "status": "healthy", "latency_ms": 5 },
    "redis": { "status": "healthy", "latency_ms": 2 },
    "external_api": { "status": "degraded", "latency_ms": 1500 }
  }
}
```

---

## Distributed Tracing (OpenTelemetry)

### When to Use

| Scenario | Need Tracing? |
|----------|--------------|
| Single service | Usually no, logs sufficient |
| 2-3 services | Helpful for debugging |
| Microservices (4+) | Essential |
| Async workflows | Essential |

### Trace Context Propagation

```
Client -> API Gateway -> Auth Service -> User Service -> Database
  |           |              |               |             |
  trace_id: abc-123 (same across all services)
  span_id:  unique per service call
```

---

## Dashboard Design

### Essential Dashboards

| Dashboard | Contents |
|-----------|----------|
| **Service Overview** | Request rate, error rate, latency (RED) |
| **Infrastructure** | CPU, memory, disk, network (USE) |
| **Business** | Signups, conversions, revenue |
| **Deployment** | Deploy frequency, rollback rate, lead time |

### Dashboard Principles

- **Start with the user experience** (latency, errors)
- **Drill down from overview to detail**
- **Time-series graphs for trends**
- **Counters for current state**
- **Red/yellow/green for status at a glance**

---

## Stack Recommendations (2025)

| Need | Self-Hosted | Managed |
|------|-------------|---------|
| Logging | ELK Stack, Loki | Datadog, Logtail |
| Metrics | Prometheus + Grafana | Datadog, CloudWatch |
| Tracing | Jaeger, Tempo | Datadog, Honeycomb |
| Alerting | Alertmanager | PagerDuty, OpsGenie |
| All-in-one | Grafana Stack | Datadog, New Relic |
| Error tracking | Sentry (self-host) | Sentry, Bugsnag |

---

## Review Checklist

- [ ] Structured JSON logging configured
- [ ] Request ID propagated across all services
- [ ] No sensitive data in logs
- [ ] Health check endpoint implemented
- [ ] Key metrics (RED/USE) being collected
- [ ] Alerts are actionable with runbooks
- [ ] Error tracking service configured (e.g. Sentry)
- [ ] Dashboards for service overview exist
- [ ] Log retention policy defined
- [ ] Tracing enabled (if multi-service)

---

## SLI/SLO Management & Error Budgets

### SLI Definition

Service Level Indicators (SLIs) are quantitative measures of service behavior. Define them based on user-facing behavior.

| SLI Type | Measurement | Example |
|----------|-------------|---------|
| **Availability** | Successful requests / total requests | 99.9% of requests return non-5xx |
| **Latency** | % requests faster than threshold | 95% of requests < 200ms |
| **Quality** | % responses that are correct/complete | 99.5% of responses have full data |
| **Throughput** | Sustained request handling rate | Sustains 10K req/s without degradation |

### SLO Establishment

| Step | Action |
|------|--------|
| 1. Identify user journeys | Map critical paths users take |
| 2. Define SLIs per journey | Pick measurable indicators |
| 3. Set targets with stakeholders | Align reliability goals with business |
| 4. Calculate error budgets | 100% - SLO = error budget |
| 5. Build burn-rate alerts | Alert when budget consumed too fast |

### Error Budget Calculation

```
SLO: 99.9% availability
Error Budget: 0.1% = 43.2 minutes/month

Burn Rate Alert Thresholds:
- 14.4x burn rate → Page (budget gone in 1 hour)
- 6x burn rate → Ticket (budget gone in 2.5 days)
- 1x burn rate → Dashboard review
```

### SLO Best Practices

- Set SLOs below what you can achieve (leave room for innovation)
- Use error budgets to balance reliability vs. feature velocity
- Review and adjust SLOs quarterly
- Avoid setting SLOs without stakeholder alignment and data validation

---

## OpenTelemetry & Modern Standards

### OpenTelemetry Collector

| Component | Purpose |
|-----------|---------|
| **Receivers** | Ingest telemetry (OTLP, Jaeger, Prometheus) |
| **Processors** | Transform, filter, batch, sample |
| **Exporters** | Send to backends (Jaeger, Prometheus, Datadog) |

### Instrumentation Approaches

| Approach | When to Use |
|----------|------------|
| **Auto-instrumentation** | Quick start, standard frameworks |
| **Manual instrumentation** | Custom business logic, specific spans |
| **SDK instrumentation** | Libraries and shared components |

### Trace Sampling Strategies

| Strategy | Use Case |
|----------|----------|
| **Head-based** | Simple, predictable sampling rate |
| **Tail-based** | Keep interesting traces (errors, slow) |
| **Priority-based** | Always sample critical paths |

### Migration from Proprietary

1. Deploy OTel collector as a sidecar or gateway
2. Configure dual-export (old + new backend)
3. Gradually switch instrumentation to OTel SDK
4. Validate data parity, then decommission old agent

---

## Infrastructure & Platform Monitoring

### Kubernetes Monitoring

| Layer | What to Monitor | Tools |
|-------|----------------|-------|
| **Cluster** | Node health, resource utilization | Prometheus Operator, kube-state-metrics |
| **Pod** | Container CPU/memory, restarts | cAdvisor, kubelet metrics |
| **Application** | Custom metrics, request rates | OTel SDK, Prometheus client libraries |
| **Network** | Service mesh telemetry, DNS | Istio/Envoy metrics, CoreDNS |

### Cloud Provider Monitoring

| Provider | Native Tools | Integration |
|----------|-------------|-------------|
| **AWS** | CloudWatch, X-Ray | CloudWatch exporter for Prometheus |
| **GCP** | Cloud Monitoring, Cloud Trace | Stackdriver integration |
| **Azure** | Monitor, App Insights | Azure Monitor exporter |

### Database Monitoring

| Database | Key Metrics |
|----------|-------------|
| **PostgreSQL** | Active connections, query duration, dead tuples, replication lag |
| **Redis** | Memory usage, hit rate, connected clients, evictions |
| **MongoDB** | Op counters, document metrics, replication lag |

---

## Chaos Engineering & Reliability Testing

### Approach

| Phase | Action |
|-------|--------|
| 1. **Hypothesize** | Define expected system behavior under failure |
| 2. **Inject fault** | Use Chaos Monkey, Gremlin, or Litmus |
| 3. **Observe** | Monitor dashboards and alerts during experiment |
| 4. **Learn** | Document findings, improve resilience |

### Common Experiments

| Experiment | What It Tests |
|------------|--------------|
| Kill pod/instance | Auto-recovery and failover |
| Network partition | Service isolation and graceful degradation |
| Latency injection | Timeout handling and circuit breakers |
| Disk fill | Storage alerts and cleanup procedures |
| DNS failure | Fallback resolution and caching |

### RTO/RPO Validation

- **RTO (Recovery Time Objective)**: Max acceptable downtime
- **RPO (Recovery Point Objective)**: Max acceptable data loss
- Test both regularly through chaos experiments and DR drills

---

## Alerting & Incident Response (Extended)

### On-Call Management

| Practice | Guideline |
|----------|-----------|
| Rotation length | 1 week, with handoff documentation |
| Escalation policy | Primary -> Secondary -> Manager (15 min each) |
| Fatigue prevention | Max 2 pages/night, compensatory time off |
| Runbook automation | Auto-remediation for known issues |

### Post-Incident Process

1. **Stabilize**: Restore service first
2. **Communicate**: Status page update within 5 minutes
3. **Investigate**: Timeline of events, root cause analysis
4. **Blameless postmortem**: Focus on systemic improvements
5. **Action items**: Track remediation with owners and deadlines

### Alert Correlation & Noise Reduction

| Technique | How |
|-----------|-----|
| **Grouping** | Cluster related alerts by service/component |
| **Deduplication** | Suppress identical alerts within a window |
| **Intelligent routing** | Route based on service ownership |
| **ML-based clustering** | Auto-group anomalous patterns |

---

## Observability as Code

### Infrastructure as Code for Monitoring

| Tool | Use Case |
|------|----------|
| **Terraform** | Provision monitoring infrastructure (Prometheus, Grafana) |
| **Ansible** | Deploy and configure monitoring agents |
| **Helm charts** | Kubernetes monitoring stack deployment |

### GitOps for Dashboards & Alerts

- Store Grafana dashboards as JSON in version control
- Use Alertmanager config files in Git with PR review
- Automate monitoring setup for new services via CI/CD
- Apply policy-as-code for compliance and governance

---

## Cost Optimization

| Strategy | Impact |
|----------|--------|
| **Sampling** | Reduce trace/log volume by 80-90% with tail-based sampling |
| **Tiered storage** | Hot (7d) -> Warm (30d) -> Cold (1yr) for metrics/logs |
| **Retention policies** | Auto-delete debug logs after 7 days |
| **Cardinality control** | Limit label combinations to avoid metric explosion |
| **Right-sizing** | Match monitoring infra to actual load |

---

## Enterprise Compliance Monitoring

| Standard | Monitoring Requirements |
|----------|------------------------|
| **SOC2** | Audit logs, access tracking, change detection |
| **PCI DSS** | Log all access to cardholder data, 1-year retention |
| **HIPAA** | PHI access logging, encryption monitoring |
| **GDPR** | Data access auditing, right-to-erasure tracking |

---

## AI/ML-Driven Observability

| Capability | Application |
|------------|-------------|
| **Anomaly detection** | Statistical models and ML to detect unusual patterns |
| **Predictive analytics** | Forecast capacity needs and potential failures |
| **Root cause analysis** | Correlation analysis and pattern recognition |
| **Intelligent clustering** | Auto-group alerts to reduce noise |
| **Time-series forecasting** | Proactive scaling and maintenance scheduling |
| **Log analysis with NLP** | Categorize and extract insights from log text |
