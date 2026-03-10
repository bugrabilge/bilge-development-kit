---
user-invocable: false
name: parallel-agents
description: "Multi-agent orchestration patterns, architecture design, optimization, and coordination. Use when multiple independent tasks can run with different domain expertise, when comprehensive analysis requires multiple perspectives, or when optimizing multi-agent performance."
allowed-tools: Read, Glob, Grep
---

# Native Parallel Agents

> Orchestration through Antigravity's built-in Agent Tool

## Overview

This skill enables coordinating multiple specialized agents through Antigravity's native agent system. Unlike external scripts, this approach keeps all orchestration within Antigravity's control.

## When to Use Orchestration

✅ **Good for:**
- Complex tasks requiring multiple expertise domains
- Code analysis from security, performance, and quality perspectives
- Comprehensive reviews (architecture + security + testing)
- Feature implementation needing backend + frontend + database work

❌ **Not for:**
- Simple, single-domain tasks
- Quick fixes or small changes
- Tasks where one agent suffices

---

## Native Agent Invocation

### Single Agent
```
Use the security-auditor agent to review authentication
```

### Sequential Chain
```
First, use the explorer-agent to discover project structure.
Then, use the backend-specialist to review API endpoints.
Finally, use the test-engineer to identify test gaps.
```

### With Context Passing
```
Use the frontend-specialist to analyze React components.
Based on those findings, have the test-engineer generate component tests.
```

### Resume Previous Work
```
Resume agent [agentId] and continue with additional requirements.
```

---

## Orchestration Patterns

### Pattern 1: Comprehensive Analysis
```
Agents: explorer-agent → [domain-agents] → synthesis

1. explorer-agent: Map codebase structure
2. security-auditor: Security posture
3. backend-specialist: API quality
4. frontend-specialist: UI/UX patterns
5. test-engineer: Test coverage
6. Synthesize all findings
```

### Pattern 2: Feature Review
```
Agents: affected-domain-agents → test-engineer

1. Identify affected domains (backend? frontend? both?)
2. Invoke relevant domain agents
3. test-engineer verifies changes
4. Synthesize recommendations
```

### Pattern 3: Security Audit
```
Agents: security-auditor → penetration-tester → synthesis

1. security-auditor: Configuration and code review
2. penetration-tester: Active vulnerability testing
3. Synthesize with prioritized remediation
```

---

## Available Agents

| Agent | Expertise | Trigger Phrases |
|-------|-----------|-----------------|
| `orchestrator` | Coordination | "comprehensive", "multi-perspective" |
| `security-auditor` | Security | "security", "auth", "vulnerabilities" |
| `penetration-tester` | Security Testing | "pentest", "red team", "exploit" |
| `backend-specialist` | Backend | "API", "server", "Node.js", "Express" |
| `frontend-specialist` | Frontend | "React", "UI", "components", "Next.js" |
| `test-engineer` | Testing | "tests", "coverage", "TDD" |
| `devops-engineer` | DevOps | "deploy", "CI/CD", "infrastructure" |
| `database-architect` | Database | "schema", "Prisma", "migrations" |
| `mobile-developer` | Mobile | "React Native", "Flutter", "mobile" |
| `api-designer` | API Design | "REST", "GraphQL", "OpenAPI" |
| `debugger` | Debugging | "bug", "error", "not working" |
| `explorer-agent` | Discovery | "explore", "map", "structure" |
| `documentation-writer` | Documentation | "write docs", "create README", "generate API docs" |
| `performance-optimizer` | Performance | "slow", "optimize", "profiling" |
| `project-planner` | Planning | "plan", "roadmap", "milestones" |
| `seo-specialist` | SEO | "SEO", "meta tags", "search ranking" |
| `game-developer` | Game Development | "game", "Unity", "Godot", "Phaser" |

---

## Antigravity Built-in Agents

These work alongside custom agents:

| Agent | Model | Purpose |
|-------|-------|---------|
| **Explore** | Haiku | Fast read-only codebase search |
| **Plan** | Sonnet | Research during plan mode |
| **General-purpose** | Sonnet | Complex multi-step modifications |

Use **Explore** for quick searches, **custom agents** for domain expertise.

---

## Synthesis Protocol

After all agents complete, synthesize:

```markdown
## Orchestration Synthesis

### Task Summary
[What was accomplished]

### Agent Contributions
| Agent | Finding |
|-------|---------|
| security-auditor | Found X |
| backend-specialist | Identified Y |

### Consolidated Recommendations
1. **Critical**: [Issue from Agent A]
2. **Important**: [Issue from Agent B]
3. **Nice-to-have**: [Enhancement from Agent C]

### Action Items
- [ ] Fix critical security issue
- [ ] Refactor API endpoint
- [ ] Add missing tests
```

---

## Best Practices

1. **Available agents** - 17 specialized agents can be orchestrated
2. **Logical order** - Discovery → Analysis → Implementation → Testing
3. **Share context** - Pass relevant findings to subsequent agents
4. **Single synthesis** - One unified report, not separate outputs
5. **Verify changes** - Always include test-engineer for code modifications

---

## Key Benefits

- ✅ **Single session** - All agents share context
- ✅ **AI-controlled** - Claude orchestrates autonomously
- ✅ **Native integration** - Works with built-in Explore, Plan agents
- ✅ **Resume support** - Can continue previous agent work
- ✅ **Context passing** - Findings flow between agents

---

## Multi-Agent Architecture Theory

### Why Multi-Agent Architectures

**The Context Bottleneck**: Single agents face inherent ceilings in reasoning capability, context management, and tool coordination. As tasks grow complex, context windows fill and performance degrades via the lost-in-middle effect, attention scarcity, and context poisoning. Multi-agent architectures partition work across multiple clean context windows.

**Token Economics Reality**:

| Architecture | Token Multiplier | Use Case |
|--------------|------------------|----------|
| Single agent chat | 1x baseline | Simple queries |
| Single agent with tools | ~4x baseline | Tool-using tasks |
| Multi-agent system | ~15x baseline | Complex research/coordination |

**The Parallelization Argument**: Many tasks contain parallelizable subtasks. Multi-agent architectures assign each to a dedicated agent with fresh context, reducing total time to the longest subtask rather than the sum.

**The Specialization Argument**: Different tasks benefit from different system prompts, tool sets, and context structures. Specialized agents carry only what they need.

### Architectural Patterns (Detailed)

**Supervisor/Orchestrator**: Central agent delegates to specialists and synthesizes results. Best for tasks with clear decomposition and where human oversight is important. Risk: supervisor context becomes bottleneck; "telephone game" problem where supervisors paraphrase sub-agent responses incorrectly.

**Telephone Game Fix**: Implement a `forward_message` tool allowing sub-agents to pass responses directly to users without supervisor synthesis when appropriate.

**Peer-to-Peer/Swarm**: No central control; agents communicate directly via handoff mechanisms. Best for flexible exploration where rigid planning is counterproductive. Risk: coordination complexity and divergence without central state.

**Hierarchical**: Strategy layer (goals) -> Planning layer (decomposition) -> Execution layer (atomic tasks). Best for large-scale projects with clear hierarchical structure.

### Context Isolation as Design Principle

The primary purpose of multi-agent architectures is context isolation. Three mechanisms:
- **Full context delegation**: Sub-agent gets complete context (max capability, defeats isolation purpose)
- **Instruction passing**: Sub-agent gets only instructions (maintains isolation, limits flexibility)
- **File system memory**: Agents read/write persistent storage (shared state without context bloat)

### Consensus and Coordination

- **Weighted Voting**: Weight by confidence or domain expertise, not simple majority
- **Debate Protocols**: Adversarial critique yields higher accuracy than collaborative consensus
- **Trigger-Based Intervention**: Monitor for stalls and sycophancy (agents mimicking without unique reasoning)

### Failure Modes and Mitigations

| Failure | Mitigation |
|---------|-----------|
| Supervisor Bottleneck | Output schema constraints; workers return distilled summaries; checkpointing |
| Coordination Overhead | Clear handoff protocols; batch results; async communication |
| Divergence | Clear objective boundaries; convergence checks; time-to-live limits |
| Error Propagation | Validate outputs before passing; retry with circuit breakers; idempotent operations |

---

## Multi-Agent Optimization

### Performance Profiling

Profile across layers with specialized agents:
1. **Database Performance Agent**: Query execution time, index utilization, resource consumption
2. **Application Performance Agent**: CPU/memory profiling, algorithmic complexity, concurrency analysis
3. **Frontend Performance Agent**: Rendering metrics, network optimization, Core Web Vitals

### Context Window Optimization
- Intelligent context compression with semantic relevance filtering
- Dynamic context window resizing and token budget management

### Agent Coordination Efficiency
- Parallel execution design with minimal inter-agent communication overhead
- Dynamic workload distribution with fault-tolerant interactions

```python
class MultiAgentOrchestrator:
    def __init__(self, agents):
        self.agents = agents
        self.execution_queue = PriorityQueue()
        self.performance_tracker = PerformanceTracker()

    def optimize(self, target_system):
        with concurrent.futures.ThreadPoolExecutor() as executor:
            futures = {
                executor.submit(agent.optimize, target_system): agent
                for agent in self.agents
            }
            for future in concurrent.futures.as_completed(futures):
                agent = futures[future]
                result = future.result()
                self.performance_tracker.log(agent, result)
```

### Cost Optimization Strategies
- Token usage tracking and adaptive model selection
- Caching and result reuse across agents
- Dynamic model selection based on task complexity and budget

### Latency Reduction
- Predictive caching and pre-warming agent contexts
- Intelligent result memoization
- Reduced round-trip communication

### Monitoring and Continuous Improvement
- Real-time performance dashboards
- Automated optimization feedback loops
- Quality vs speed tradeoff management

### Key Optimization Principles
- Always measure before and after optimization
- Maintain system stability during optimization
- Balance performance gains with resource consumption
- Implement gradual, reversible changes

### Framework References
- [LangGraph](https://langchain-ai.github.io/langgraph/) - Multi-agent patterns and state management
- [AutoGen](https://microsoft.github.io/autogen/) - GroupChat and conversational patterns
- [CrewAI](https://docs.crewai.com/) - Hierarchical agent processes
