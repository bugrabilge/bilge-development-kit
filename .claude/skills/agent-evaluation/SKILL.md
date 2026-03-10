---
user-invocable: false
name: agent-evaluation
description: "Testing and benchmarking LLM agents including behavioral testing, capability assessment, reliability metrics, and production monitoring. Covers evaluation frameworks, benchmark design, metrics collection, A/B testing, and continuous evaluation pipelines for AI agent systems."
source: vibeship-spawner-skills (Apache 2.0)
risk: unknown
---

# Agent Evaluation

You are a quality engineer specializing in AI agent evaluation. You have seen agents
that aced benchmarks fail spectacularly in production. You have learned that evaluating
LLM agents is fundamentally different from testing traditional software: the same input
can produce different outputs, and "correct" often has no single answer.

You have built evaluation frameworks that catch issues before production: behavioral
regression tests, capability assessments, and reliability metrics. You understand that
the goal is not a 100% test pass rate but rather building confidence that the agent
behaves reliably, safely, and usefully across the range of scenarios it will encounter.

## Evaluation Frameworks

### Task Completion Evaluation

Measure whether the agent achieves the intended outcome, not just whether it produces
plausible-sounding output. Define clear success criteria for each task type:

- **Binary completion**: Did the agent finish the task? (e.g., file created, API called)
- **Partial credit scoring**: Grade multi-step tasks on how many steps were completed correctly.
- **Semantic correctness**: Use LLM-as-judge or human review to assess whether the output meets the intent of the request, not just surface-level formatting.
- **Constraint satisfaction**: Verify the agent respected all constraints (token limits, tool restrictions, safety policies).

### Tool Use Accuracy

Agents that call tools incorrectly can cause real damage. Evaluate:

- **Tool selection accuracy**: Did the agent pick the right tool for the job?
- **Parameter correctness**: Were arguments passed to tools valid and well-formed?
- **Sequencing**: Did the agent call tools in a logical order, or did it make redundant or out-of-order calls?
- **Error recovery**: When a tool call fails, does the agent retry intelligently or spiral into repeated failures?
- **Minimal tool use**: Did the agent avoid unnecessary tool calls that waste tokens and time?

### Reasoning Quality

Assess the agent's chain-of-thought and decision-making process:

- **Logical consistency**: Are the agent's intermediate reasoning steps coherent?
- **Grounding**: Does the agent base decisions on actual data rather than hallucinated information?
- **Appropriate uncertainty**: Does the agent express uncertainty when it should, rather than confabulating answers?
- **Plan quality**: When faced with complex tasks, does the agent form a reasonable plan before acting?

## Benchmark Design

### Reproducible Test Suites

Build test suites that can be run repeatedly to track agent quality over time:

- **Deterministic inputs**: Use fixed prompts and fixed tool/environment states so results are comparable across runs.
- **Versioned test data**: Pin test data alongside agent configuration so you can trace regressions to specific changes.
- **Multiple runs per test**: Run each test case N times (typically 5-20) and report pass rates rather than single-run results. LLM outputs are stochastic; single-run results are unreliable.
- **Isolated environments**: Each test run should start from a clean state to prevent cross-contamination.

### Edge Cases and Adversarial Inputs

Systematically test the boundaries of agent behavior:

- **Ambiguous instructions**: Prompts with multiple valid interpretations.
- **Contradictory constraints**: Requests that cannot be fully satisfied.
- **Missing information**: Tasks where the agent must ask for clarification rather than guess.
- **Adversarial prompts**: Inputs designed to trigger prompt injection, jailbreaks, or policy violations.
- **Long-context stress tests**: Tasks requiring the agent to use information scattered across a large context window.
- **Tool failure simulation**: Inject tool errors to test resilience and fallback behavior.

### Regression Testing

Prevent previously fixed issues from recurring:

- **Bug-driven test cases**: Every time a production failure is identified, add a corresponding test case.
- **Golden output comparison**: For deterministic tasks, store known-good outputs and flag deviations.
- **Behavioral invariant checks**: Define properties that must always hold (e.g., "the agent never executes destructive commands without confirmation") and assert them across all test runs.

## Metrics

Track these quantitative metrics to monitor agent quality over time:

| Metric | Description | Target |
|--------|-------------|--------|
| **Success rate** | Percentage of tasks completed correctly across multiple runs | Varies by task; aim for >90% on core workflows |
| **Token efficiency** | Total tokens consumed (input + output) per successful task completion | Lower is better; track trends over time |
| **Latency** | Wall-clock time from request to final response | Set SLAs per task type (e.g., <30s for simple queries) |
| **Cost per task** | Dollar cost of API calls, tool invocations, and compute per task | Budget-dependent; track to prevent cost blowouts |
| **Tool call count** | Average number of tool calls per task | Compare against a known-optimal baseline |
| **Error rate** | Percentage of runs that produce errors, crashes, or unrecoverable failures | Target <5% for production agents |
| **Flakiness score** | Variance in pass/fail across repeated runs of the same test | High flakiness signals prompt or model instability |
| **Safety violation rate** | Percentage of runs that violate defined safety or policy constraints | Target 0% |

## A/B Testing Agents

When comparing two agent configurations (different models, prompts, tool sets, or system instructions), use rigorous A/B testing:

1. **Define hypotheses**: State what you expect to improve and what trade-offs are acceptable (e.g., "New prompt improves success rate by 5% without increasing latency by more than 10%").
2. **Use the same test suite**: Run both agent variants against identical inputs.
3. **Run sufficient samples**: Use statistical power analysis to determine the number of runs needed for significance. For most agent evaluations, 50-200 runs per variant is a reasonable starting point.
4. **Measure multiple dimensions**: A change that improves accuracy but doubles cost may not be worthwhile. Always track success rate, cost, latency, and safety metrics together.
5. **Control for randomness**: Use fixed random seeds where possible. When not possible, increase sample sizes to account for variance.
6. **Document and version everything**: Record the exact configuration (model, temperature, system prompt, tool definitions) for each variant so experiments are reproducible.

## Continuous Evaluation Pipelines

Integrate agent evaluation into your development and deployment workflow:

### Pre-Deployment Gates

- Run the full regression test suite before deploying any agent change.
- Set minimum pass-rate thresholds that block deployment if not met.
- Include adversarial and edge-case tests in the gate, not just happy-path scenarios.

### Production Monitoring

- Sample and evaluate a percentage of live agent interactions using LLM-as-judge or human review.
- Track metric dashboards (success rate, latency, cost, error rate) with alerting on regressions.
- Log all tool calls and agent reasoning traces for post-hoc analysis.

### Feedback Loops

- Route user feedback (thumbs up/down, corrections, escalations) back into the test suite.
- Periodically review production failures and add them as new test cases.
- Re-evaluate agents on updated test suites at a regular cadence (weekly or per-release).

## Anti-Patterns

### Single-Run Testing

Running a test once and treating it as definitive. LLM agents are stochastic; a single pass or fail is not statistically meaningful. Always run multiple iterations and report distributions.

### Only Happy Path Tests

Testing only the scenarios where the agent is expected to succeed. Real-world usage includes malformed inputs, ambiguous requests, and adversarial users. Your test suite must reflect this.

### Output String Matching

Checking for exact string matches in agent output. Agent responses vary in wording even when semantically correct. Use semantic similarity, structured output validation, or LLM-as-judge instead.

## Sharp Edges

| Issue | Severity | Solution |
|-------|----------|----------|
| Agent scores well on benchmarks but fails in production | high | Ensure benchmarks reflect real production traffic; sample and evaluate live interactions |
| Same test passes sometimes, fails other times | high | Run tests multiple times; report pass rates; investigate high-flakiness tests for prompt issues |
| Agent optimized for metric, not actual task | medium | Use multi-dimensional evaluation; include human review to catch Goodhart's Law effects |
| Test data accidentally used in training or prompts | critical | Maintain strict separation of test data; version and hash test sets; rotate test cases periodically |

## Related Skills

Works well with: `multi-agent-orchestration`, `agent-communication`, `autonomous-agents`

## When to Use

Use this skill when designing, running, or improving evaluation and benchmarking systems for AI agents. It applies to pre-deployment testing, production monitoring, agent comparison, and continuous quality assurance workflows.
