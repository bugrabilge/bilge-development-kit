---
user-invocable: false
name: rust-pro
description: "Rust ownership, borrowing, lifetimes, error handling, async programming, concurrency patterns, and idiomatic Rust. Use when writing, reviewing, or debugging Rust code."
---

# Rust Pro

> "In Rust, the compiler is your strictest code reviewer and your most reliable safety net."

## When to Use
- Writing new Rust code or modules
- Reviewing Rust code for idiomatic patterns
- Debugging ownership, borrowing, or lifetime errors
- Implementing async Rust with Tokio or async-std
- Designing concurrent systems with Rust's guarantees
- Choosing between Rust abstractions (trait objects vs. generics, Arc vs. Rc)

## Ownership and Borrowing

### Core Rules
1. Each value has exactly one owner
2. When the owner goes out of scope, the value is dropped
3. You can have either one mutable reference OR any number of immutable references (not both)

### When to Clone vs. Borrow
- Borrow (&T or &mut T) by default; cloning is a last resort, not a first instinct
- Clone when you need independent ownership (e.g., sending data to another thread)
- Clone when the data is small and cheap to copy (small strings, numbers, small structs)
- Use Cow<'_, T> when you sometimes need to own and sometimes need to borrow

### Common Ownership Patterns
```rust
// Transfer ownership
fn process(data: Vec<u8>) { /* owns data, dropped at end */ }

// Borrow immutably
fn analyze(data: &[u8]) -> usize { data.len() }

// Borrow mutably
fn transform(data: &mut Vec<u8>) { data.push(0); }

// Return owned data
fn create() -> Vec<u8> { vec![1, 2, 3] }
```

### Avoiding Borrow Checker Fights
- Structure code so borrows have clear, non-overlapping scopes
- Split structs if one field's borrow conflicts with another's mutation
- Use indices instead of references into collections you need to mutate
- Consider interior mutability (RefCell, Mutex) when shared mutable state is truly needed

## Lifetimes

### When Annotations Are Needed
- Function signatures with references in both input and output
- Struct definitions that hold references
- Impl blocks for structs with lifetime parameters

### Lifetime Elision Rules
1. Each input reference gets its own lifetime parameter
2. If there is exactly one input lifetime, it is assigned to all output lifetimes
3. If one input is &self or &mut self, its lifetime is assigned to all outputs

### Practical Patterns
```rust
// Explicit lifetime: output borrows from input
fn first_word(s: &str) -> &str {
    s.split_whitespace().next().unwrap_or("")
}

// Struct holding a reference
struct Parser<'a> {
    input: &'a str,
    position: usize,
}

// When in doubt, make it owned
// Use String instead of &str in structs unless you have a clear lifetime story
```

### 'static Lifetime
- Means the data lives for the entire program duration
- String literals are 'static: `let s: &'static str = "hello";`
- Required by many async runtimes for spawned tasks
- Owned types (String, Vec) satisfy 'static bounds because they own their data

## Error Handling

### The Error Hierarchy
- Use Result<T, E> for recoverable errors; never panic for expected failures
- Use Option<T> for absence of a value (not an error condition)
- Reserve panic! for programmer errors and unrecoverable invariant violations

### Custom Error Types
```rust
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("Database error: {0}")]
    Database(#[from] sqlx::Error),

    #[error("Not found: {entity} with id {id}")]
    NotFound { entity: &'static str, id: String },

    #[error("Validation failed: {0}")]
    Validation(String),

    #[error(transparent)]
    Unexpected(#[from] anyhow::Error),
}
```

### Error Handling Best Practices
- Use `thiserror` for library error types (structured, typed errors)
- Use `anyhow` for application-level error handling (convenient, context-rich)
- Add context with `.context("what was being done")` from anyhow
- Use `?` operator for propagation; avoid explicit match on every Result
- Map errors at boundaries (e.g., convert DB errors to API errors in the controller layer)

## Async Rust

### Runtime Choice
- Tokio: most popular, full-featured, best ecosystem support
- async-std: simpler API, mirrors std library naming
- Choose one runtime per project; do not mix

### Async Patterns
```rust
// Spawning concurrent tasks
let (a, b) = tokio::join!(fetch_users(), fetch_orders());

// Spawning independent tasks
let handle = tokio::spawn(async move {
    process(data).await
});
let result = handle.await?;

// Select first to complete
tokio::select! {
    result = operation() => handle_result(result),
    _ = tokio::time::sleep(Duration::from_secs(5)) => handle_timeout(),
}
```

### Async Pitfalls
- Do not hold a MutexGuard (std or tokio) across an await point
- Use `tokio::sync::Mutex` if you must hold a lock across awaits
- Avoid blocking the async runtime: use `tokio::task::spawn_blocking` for CPU work
- Ensure futures are Send + 'static when spawning tasks (no non-Send references held across awaits)
- Use `#[tokio::main]` on main, not manual runtime building, unless you need custom config

## Concurrency Patterns

### Shared State
- `Arc<Mutex<T>>` for shared mutable state across threads
- `Arc<RwLock<T>>` when reads vastly outnumber writes
- `DashMap` for concurrent hashmap without manual locking
- Prefer message passing (channels) over shared state when possible

### Channels
```rust
// mpsc: multiple producers, single consumer
let (tx, mut rx) = tokio::sync::mpsc::channel(100);

// oneshot: single value, single send
let (tx, rx) = tokio::sync::oneshot::channel();

// broadcast: multiple consumers, each gets every message
let (tx, _) = tokio::sync::broadcast::channel(100);

// watch: single producer, multiple consumers, latest value only
let (tx, rx) = tokio::sync::watch::channel(initial_value);
```

### Rayon for CPU Parallelism
- Use Rayon for data-parallel CPU work (parallel iterators)
- Do not use Rayon inside async contexts; use spawn_blocking as a bridge
- `par_iter()`, `par_chunks()` for embarrassingly parallel operations

## Idiomatic Rust

### Iterators Over Loops
```rust
// Prefer this
let names: Vec<String> = users.iter().map(|u| u.name.clone()).collect();

// Over this
let mut names = Vec::new();
for u in &users {
    names.push(u.name.clone());
}
```

### Builder Pattern
- Use for structs with many optional fields
- Return &mut Self for chaining; provide a build() method that validates and returns Result

### Newtype Pattern
- Wrap primitive types to add type safety: `struct UserId(u64);`
- Prevents mixing up IDs of different entities at compile time
- Implement Deref only if the newtype truly "is a" the inner type

### Trait Design
- Keep traits small and focused (Interface Segregation Principle)
- Provide default method implementations where a sensible default exists
- Use associated types over generic parameters when there is one natural choice
- Prefer generic bounds (`impl Trait` or `where T: Trait`) over trait objects (`dyn Trait`) for performance

## Performance Tips
- Prefer &str over String in function parameters
- Use Vec::with_capacity when the size is known in advance
- Avoid unnecessary allocations in hot loops
- Use `#[inline]` sparingly; let the compiler decide in most cases
- Profile before optimizing: use cargo flamegraph, criterion for benchmarks
- Prefer stack allocation (arrays, small structs) over heap allocation where possible

## Project Structure
```
src/
  main.rs or lib.rs
  config.rs
  error.rs          # Custom error types
  models/           # Data structures
  handlers/         # Request handlers (for web servers)
  services/         # Business logic
  db/               # Database access
tests/
  integration/      # Integration tests
benches/            # Criterion benchmarks
```
