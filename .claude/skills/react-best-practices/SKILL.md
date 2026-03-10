---
user-invocable: false
name: react-best-practices
description: "React component patterns, hooks usage, state management, performance optimization, and accessibility. Use when building React UIs, reviewing components, or optimizing rendering."
---

# React Best Practices

> "Components should be like pure functions: predictable, composable, and easy to reason about."

## When to Use
- Building new React components or pages
- Reviewing React code for anti-patterns
- Optimizing rendering performance
- Choosing state management approaches
- Implementing accessible interactive components
- Structuring a React project

## Component Design Principles

### Composition Over Configuration
- Prefer composable children over deeply nested prop configs
- Use the compound component pattern for related UI pieces
- Avoid prop drilling beyond 2 levels; use context or composition instead

### Single Responsibility
- Each component should do one thing well
- If a component file exceeds 200 lines, consider splitting
- Separate data-fetching logic from presentation logic

### Component Naming
- PascalCase for component names matching the file name
- Prefix context providers with their domain (e.g., AuthProvider, ThemeProvider)
- Use descriptive names: UserProfileCard, not Card or UPC

## Hooks Patterns

### useState
- Use for simple, local UI state (toggles, form inputs, counters)
- Initialize with a function for expensive computations: `useState(() => compute())`
- Group related state into an object or use useReducer when state transitions are complex

### useEffect
- Always specify a dependency array
- Return a cleanup function for subscriptions, timers, and event listeners
- Avoid using useEffect for derived state; compute it during render instead
- Do not use useEffect to sync props to state (this is almost always a bug)

### useReducer
- Prefer over useState when next state depends on previous state
- Use for state machines and complex multi-field forms
- Keep reducer functions pure and outside the component

### useMemo and useCallback
- Do not prematurely optimize; measure first with React DevTools Profiler
- Use useMemo for expensive computations that depend on specific inputs
- Use useCallback for functions passed to memoized child components
- Both are optimization hints, not semantic guarantees

### Custom Hooks
- Extract reusable logic into custom hooks prefixed with "use"
- Custom hooks should return the minimal necessary interface
- Examples: useDebounce, useLocalStorage, useMediaQuery, useIntersectionObserver
- Test custom hooks with renderHook from @testing-library/react

## State Management

### Local State (useState / useReducer)
- Default choice; keep state as close to where it is used as possible
- Lift state up only when siblings need to share it

### Context API
- Use for low-frequency updates: theme, locale, auth status
- Do not use for high-frequency updates (e.g., mouse position, rapidly changing forms)
- Split contexts by domain to avoid unnecessary re-renders
- Provide a custom hook for each context (e.g., useAuth, useTheme)

### External State Libraries
- Use Zustand for simple global state with minimal boilerplate
- Use TanStack Query (React Query) for server state (caching, refetching, pagination)
- Use Jotai or Recoil for atomic, fine-grained reactivity
- Redux Toolkit if the team already uses Redux; avoid vanilla Redux in new projects

### Server State vs. Client State
- Server state: data fetched from APIs (use TanStack Query or SWR)
- Client state: UI state, form state, local preferences
- Never duplicate server state into client state stores; let the query cache be the source of truth

## Performance Optimization

### Preventing Unnecessary Re-renders
- Use React.memo for pure presentational components receiving complex props
- Split components so that state changes affect the smallest subtree possible
- Avoid creating new objects/arrays/functions in JSX props inline

### Virtualization
- Use react-window or @tanstack/react-virtual for long lists (100+ items)
- Implement pagination or infinite scroll for large datasets
- Never render thousands of DOM nodes simultaneously

### Code Splitting
- Use React.lazy + Suspense for route-level code splitting
- Dynamically import heavy libraries (chart libs, editors) only when needed
- Preload critical chunks with `import(/* webpackPrefetch: true */)`

### Image and Asset Optimization
- Use next/image or responsive srcset for images
- Lazy-load images below the fold with loading="lazy"
- Use SVG for icons; avoid icon fonts

## Accessibility (a11y)

### Semantic HTML
- Use button for clickable actions, a for navigation, not div with onClick
- Use headings (h1-h6) in order; do not skip levels
- Use landmark elements: nav, main, aside, header, footer

### ARIA Attributes
- Prefer native semantics over ARIA; ARIA is a last resort
- Always provide aria-label or aria-labelledby for icon-only buttons
- Use aria-live regions for dynamic content updates (toasts, loading states)
- Set role="dialog" and manage focus for modals

### Keyboard Navigation
- All interactive elements must be reachable via Tab
- Implement focus trapping in modals and dropdown menus
- Support Escape to close overlays
- Visible focus indicators are required; never set outline: none without a replacement

### Testing Accessibility
- Use eslint-plugin-jsx-a11y for static analysis
- Run axe-core or Lighthouse audits in CI
- Test with screen readers (VoiceOver, NVDA) for critical flows

## Project Structure
```
src/
  components/       # Shared/reusable UI components
    Button/
      Button.tsx
      Button.test.tsx
      Button.module.css
  features/         # Feature-based modules
    auth/
      components/
      hooks/
      api.ts
      types.ts
  hooks/            # Shared custom hooks
  utils/            # Pure utility functions
  contexts/         # React context providers
  pages/ or routes/ # Route-level components
  types/            # Shared TypeScript types
```

## Testing

### Component Testing
- Use @testing-library/react; test behavior, not implementation
- Query by role, label, or text, not by class or test-id
- Test user interactions: click, type, submit
- Avoid testing internal state or instance methods

### Integration Testing
- Test feature flows end-to-end within the React tree
- Mock API calls at the network level (MSW) not at the module level
- Verify loading, error, and success states

### Snapshot Testing
- Use sparingly; snapshots break easily and provide low-signal diffs
- Prefer explicit assertions over snapshot matching
