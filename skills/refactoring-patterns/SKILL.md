---
name: refactoring-patterns
description: "Code refactoring techniques, extract method, strategy pattern, strangler fig migration, incremental improvement, and safe transformation steps. Use when improving existing code quality, reducing technical debt, or planning migrations."
---

# Refactoring Patterns

> "Refactoring is the art of improving code without changing what it does -- small, safe, relentless steps."

## When to Use
- Improving readability or maintainability of existing code
- Reducing code duplication across a codebase
- Preparing code for new features by cleaning up the existing structure
- Planning incremental migrations from legacy to modern architecture
- Reducing technical debt methodically
- Reviewing code that has grown complex or tangled

## Foundational Principles

### The Refactoring Mindset
- Never refactor and add features in the same commit
- Each refactoring step must keep all tests passing (green-to-green)
- Make the change easy, then make the easy change
- Refactor code you are about to modify; do not refactor unrelated code opportunistically
- If you cannot explain the improvement in one sentence, the refactoring is too large

### Safety Net Requirements
- Automated tests covering the code being refactored (minimum: key paths)
- Version control with small, frequent commits (one refactoring step per commit)
- CI pipeline that runs tests on every push
- If tests do not exist, write characterization tests first (tests that document current behavior)

## Method-Level Refactorings

### Extract Method
- **When**: A code block inside a function does one identifiable subtask
- **How**: Move the block to a new function with a descriptive name, pass required variables as parameters
- **Goal**: Each function reads like a paragraph; the name tells what, the body tells how
- **Signal**: Comments explaining "what the next block does" -- replace the comment with a function name

### Inline Method
- **When**: A method body is as clear as its name, or the method is a trivial wrapper
- **How**: Replace calls with the method body; remove the method
- **Signal**: Method name adds no abstraction value over the code itself

### Replace Temp with Query
- **When**: A temporary variable holds a computed value used once
- **How**: Extract the computation into a method; call the method directly
- **Benefit**: Makes the computation reusable and testable independently

### Introduce Parameter Object
- **When**: Multiple functions pass the same group of parameters together
- **How**: Create a class/struct holding those parameters; pass the object instead
- **Benefit**: Reduces parameter count; provides a natural home for related logic

### Replace Nested Conditionals with Guard Clauses
- **When**: Deeply nested if-else blocks obscure the main logic
- **How**: Return early for edge cases; let the main path flow without nesting
- **Before**:
```
if (user) {
  if (user.isActive) {
    if (user.hasPermission) {
      doWork();
    }
  }
}
```
- **After**:
```
if (!user) return;
if (!user.isActive) return;
if (!user.hasPermission) return;
doWork();
```

## Class / Module-Level Refactorings

### Extract Class
- **When**: A class has multiple responsibilities or groups of related fields
- **How**: Move the cohesive group of fields and methods into a new class
- **Signal**: Changes to one group of fields never affect the other group

### Move Method / Move Field
- **When**: A method uses more data from another class than its own
- **How**: Move the method to the class it is most coupled with
- **Signal**: Feature envy -- a method reaching into another object's internals

### Replace Inheritance with Composition
- **When**: A subclass only uses part of the parent's behavior, or the "is-a" relationship is forced
- **How**: Create an instance of the former parent; delegate specific methods to it
- **Benefit**: Looser coupling, easier testing, more flexible combinations

### Replace Conditional with Polymorphism
- **When**: A switch/case or if-else chain selects behavior based on a type field
- **How**: Create a class hierarchy or strategy interface; each branch becomes a class
- **Benefit**: Adding new types does not require modifying existing code (Open/Closed Principle)

## Design Pattern Refactorings

### Introduce Strategy Pattern
- **When**: An algorithm varies and is selected at runtime (e.g., pricing rules, sort strategies)
- **How**: Define a strategy interface; implement each variant as a concrete strategy; inject the strategy
- **Avoid**: Over-engineering; if there are only 2 variants and unlikely to grow, a simple conditional is fine

### Introduce Factory Method
- **When**: Object creation logic is complex or varies by type
- **How**: Encapsulate creation in a factory function or method
- **Benefit**: Decouples consumers from concrete class constructors

### Replace Magic Values with Constants or Enums
- **When**: Code contains magic numbers, strings, or status codes
- **How**: Extract to named constants or enum values
- **Benefit**: Self-documenting code; single source of truth for each value

### Introduce Null Object
- **When**: Repeated null checks clutter the code
- **How**: Create a "do nothing" implementation that satisfies the interface
- **Benefit**: Eliminates null checks; polymorphism handles the absent case

## Large-Scale Refactoring Strategies

### Strangler Fig Pattern
- **When**: Migrating a legacy system to a new architecture incrementally
- **How**:
  1. Build new functionality alongside the old system
  2. Route new traffic to the new system, old traffic stays on legacy
  3. Gradually migrate features from old to new
  4. Decommission legacy once all traffic is migrated
- **Key**: Both systems coexist during the transition; no big-bang cutover
- **Infrastructure**: Use a routing layer (API gateway, reverse proxy) to direct traffic

### Branch by Abstraction
- **When**: Replacing a dependency or module that is deeply embedded
- **How**:
  1. Introduce an abstraction layer (interface) over the current implementation
  2. Update all callers to use the abstraction instead of the concrete implementation
  3. Create the new implementation behind the same abstraction
  4. Switch from old to new implementation (feature flag or config)
  5. Remove the old implementation
- **Benefit**: No long-lived feature branches; changes are integrated continuously

### Parallel Change (Expand, Migrate, Contract)
- **When**: Changing an interface that many consumers depend on
- **How**:
  1. **Expand**: Add the new interface alongside the old one
  2. **Migrate**: Update all consumers to use the new interface
  3. **Contract**: Remove the old interface once no consumers remain
- **Benefit**: No breaking changes at any step; each step is independently deployable

### Feature Flags for Safe Migration
- Wrap refactored code paths behind feature flags
- Run old and new paths in parallel (shadow mode) to compare results
- Gradually roll out the new path; rollback instantly if issues arise
- Clean up flags after migration is complete; stale flags are tech debt

## Incremental Improvement Workflow

### Step-by-Step Process
1. Identify the pain point (bug-prone area, slow-to-change module, duplicated logic)
2. Write characterization tests if none exist
3. Plan the refactoring as a sequence of small steps
4. Execute one step at a time; commit after each green test run
5. Review the result; does the code better express its intent?

### Prioritizing What to Refactor
- Code you need to modify for an upcoming feature (Boy Scout Rule)
- Areas with high bug density (frequent fixes = fragile design)
- Modules with high coupling and low cohesion
- Code that multiple teams need to modify (merge conflict hotspots)
- Do NOT refactor stable code that nobody needs to change

### Measuring Improvement
- Cyclomatic complexity reduction (fewer branches per function)
- Reduced file/function length
- Fewer merge conflicts in previously contentious files
- Faster time to implement new features in the refactored area
- Reduced bug recurrence in previously fragile code

## Code Smells Checklist
- **Long method**: Extract smaller functions
- **Large class**: Extract class or split module
- **Duplicate code**: Extract shared function or module
- **Feature envy**: Move method to the class it envies
- **Data clump**: Introduce parameter object
- **Primitive obsession**: Replace primitives with domain types
- **Shotgun surgery**: One change requires edits in many files; consolidate
- **Divergent change**: One file changes for many different reasons; split by responsibility
- **Dead code**: Delete it; version control remembers
- **Speculative generality**: Remove abstractions built for hypothetical future needs
