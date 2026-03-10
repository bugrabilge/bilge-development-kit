---
user-invocable: false
name: agent-manager-skill
description: "Manage multiple local CLI agents via tmux sessions (start/stop/monitor/assign) with cron-friendly scheduling. Includes agent performance optimization workflows."
risk: unknown
source: community
---

# Agent Manager Skill

## When to use

Use this skill when you need to:

- run multiple local CLI agents in parallel (separate tmux sessions)
- start/stop agents and tail their logs
- assign tasks to agents and monitor output
- schedule recurring agent work (cron)

## Prerequisites

Install `agent-manager-skill` in your workspace:

```bash
git clone https://github.com/fractalmind-ai/agent-manager-skill.git
```

## Common commands

```bash
python3 agent-manager/scripts/main.py doctor
python3 agent-manager/scripts/main.py list
python3 agent-manager/scripts/main.py start EMP_0001
python3 agent-manager/scripts/main.py monitor EMP_0001 --follow
python3 agent-manager/scripts/main.py assign EMP_0002 <<'EOF'
Follow teams/fractalmind-ai-maintenance.md Workflow
EOF
```

## Notes

- Requires `tmux` and `python3`.
- Agents are configured under an `agents/` directory (see the repo for examples).

---

## Agent Performance Optimization Workflow

Systematic improvement of existing agents through performance analysis, prompt engineering, and continuous iteration.

### Phase 1: Performance Analysis and Baseline

#### Gather Performance Data
Collect metrics including:
- Task completion rate (successful vs failed tasks)
- Response accuracy and factual correctness
- Tool usage efficiency (correct tools, call frequency)
- Average response time and token consumption
- User satisfaction indicators (corrections, retries)
- Hallucination incidents and error patterns

#### User Feedback Pattern Analysis
Identify recurring patterns:
- **Correction patterns**: Where users consistently modify outputs
- **Clarification requests**: Common areas of ambiguity
- **Task abandonment**: Points where users give up
- **Follow-up questions**: Indicators of incomplete responses
- **Positive feedback**: Successful patterns to preserve

#### Failure Mode Classification
Categorize failures by root cause:
- Instruction misunderstanding, output format errors
- Context loss in long conversations
- Tool misuse or inefficient tool selection
- Constraint violations, edge case handling

#### Baseline Performance Report
```
- Task Success Rate: [X%]
- Average Corrections per Task: [Y]
- Tool Call Efficiency: [Z%]
- User Satisfaction Score: [1-10]
- Average Response Latency: [Xms]
- Token Efficiency Ratio: [X:Y]
```

### Phase 2: Prompt Engineering Improvements

- **Chain-of-Thought Enhancement**: Add explicit reasoning steps and self-verification checkpoints
- **Few-Shot Example Optimization**: Curate diverse examples covering common use cases and edge cases
- **Role Definition Refinement**: Clear mission, expertise domains, behavioral traits, constraints
- **Constitutional AI Integration**: Self-correction with critique-and-revise loops
- **Output Format Tuning**: Structured templates, dynamic formatting, progressive disclosure

### Phase 3: Testing and Validation

#### A/B Testing Framework
- Minimum sample size: 100 tasks per variant
- Confidence level: 95% (p < 0.05)
- Compare: success rate, speed, token usage
- Use blind human review + automated scoring

#### Evaluation Metrics
- **Task-Level**: Completion rate, correctness, efficiency, tool appropriateness
- **Quality**: Hallucination rate, consistency, format compliance, safety
- **Performance**: Latency, token consumption, cost per task

### Phase 4: Version Control and Deployment

#### Version Management
```
Format: agent-name-v[MAJOR].[MINOR].[PATCH]
MAJOR: Significant capability changes
MINOR: Prompt improvements, new examples
PATCH: Bug fixes, minor adjustments
```

#### Staged Rollout
1. Alpha (5% traffic) -> Beta (20%) -> Canary (20-50-100%) -> Full deployment
2. 7-day monitoring period after full deployment

#### Rollback Triggers
- Success rate drops >10% from baseline
- Critical errors increase >5%
- Cost per task increases >20%
- Safety violations detected

### Success Criteria
- Task success rate improves by >=15%
- User corrections decrease by >=25%
- No increase in safety violations
- Response time remains within 10% of baseline

### Continuous Improvement Cycle
- **Weekly**: Monitor metrics and collect feedback
- **Monthly**: Analyze patterns and plan improvements
- **Quarterly**: Major version updates with new capabilities
