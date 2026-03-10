---
user-invocable: false
name: frontend-design
description: "UI/UX principles for frontend development, component architecture, design systems, responsive layouts, and interaction design. Use when architecting frontend applications or making design decisions in code."
---

# Frontend Design

> "Great frontend design is invisible; users notice only when it fails."

## When to Use
- Architecting the component structure of a frontend application
- Making UI/UX decisions during implementation
- Building or extending a design system
- Planning responsive layouts and interaction patterns
- Reviewing frontend code for design consistency and usability

## UI/UX Principles for Developers

### Clarity Over Cleverness
- Every element should have an obvious purpose
- Labels, buttons, and links should describe their action ("Save Draft" not "Submit")
- Use progressive disclosure: show only what is needed at each step
- Error states must explain what happened and what the user should do next

### Consistency
- Same action should look and behave the same everywhere
- Use consistent spacing, typography, and color throughout the application
- Follow platform conventions (e.g., confirmation dialogs, form validation patterns)
- Maintain consistent terminology across the entire product

### Feedback and Responsiveness
- Every user action must produce visible feedback within 100ms
- Use loading indicators for operations over 300ms
- Use skeleton screens instead of spinners for content loading
- Optimistic updates for low-risk actions (likes, toggles); confirm for destructive ones
- Disable buttons after submission to prevent double-clicks

### Forgiveness
- Support undo for destructive actions instead of "Are you sure?" dialogs
- Auto-save form progress where possible
- Preserve user input on navigation (back button should not lose form data)
- Provide clear, non-punishing error recovery paths

## Component Architecture

### Atomic Design Hierarchy
- **Atoms**: Smallest units (Button, Input, Label, Icon, Badge)
- **Molecules**: Combinations of atoms (SearchBar = Input + Button, FormField = Label + Input + ErrorText)
- **Organisms**: Complex sections (Header, Sidebar, UserCard, DataTable)
- **Templates**: Page-level layouts with placeholder content
- **Pages**: Templates with real data connected

### Component API Design
- Props should be minimal and focused; avoid god-components with 20+ props
- Use the "inversion of control" pattern: let consumers control rendering via render props or slots
- Provide sensible defaults for optional props
- Use TypeScript discriminated unions for variant props instead of multiple booleans

### Separation of Concerns
- **Container components**: handle data fetching, state, side effects
- **Presentational components**: receive data via props, render UI, emit events
- Keep styling co-located with the component (CSS modules, styled-components, or Tailwind)
- Business logic belongs in hooks or services, not in component bodies

### Component Composition Patterns
- **Compound components**: related components share implicit state (Tabs + Tab + TabPanel)
- **Render props / slots**: delegate rendering to the consumer for flexibility
- **Higher-order components**: use sparingly; prefer hooks for logic reuse
- **Headless components**: provide behavior without any styling (headless UI libraries)

## Design Systems

### Token Architecture
- **Colors**: primary, secondary, neutral, semantic (success, warning, error, info)
- **Typography**: font families, sizes (scale), weights, line heights
- **Spacing**: consistent scale (4px base: 4, 8, 12, 16, 24, 32, 48, 64, 96)
- **Borders**: radii, widths, colors
- **Shadows**: elevation levels (sm, md, lg, xl)
- **Motion**: duration, easing curves

### Implementation Strategy
- Store tokens as CSS custom properties or JavaScript constants
- Generate tokens from a single source (Figma tokens, JSON, Style Dictionary)
- Version the design system as a package; consumer apps pin versions
- Document each component with usage examples, dos and don'ts

### Component Library Structure
```
design-system/
  tokens/
    colors.ts
    spacing.ts
    typography.ts
  components/
    Button/
      Button.tsx
      Button.stories.tsx
      Button.test.tsx
      index.ts
    Input/
    Modal/
  hooks/
    useDisclosure.ts
    useClickOutside.ts
  utils/
    cn.ts (class name merger)
```

## Responsive Layout Strategies

### Layout Patterns
- **Stack**: vertical arrangement with consistent gap (most common)
- **Inline**: horizontal arrangement that wraps (tags, chips)
- **Sidebar**: fixed sidebar + fluid main content
- **Holy Grail**: header + sidebar + main + aside + footer
- **Dashboard grid**: responsive card grid with varying column spans

### Responsive Behavior Decisions
- What content hides on mobile vs. collapses into menus?
- Do tables become cards on small screens or horizontally scroll?
- Does the sidebar collapse to a hamburger menu or bottom nav?
- Which images get different crops vs. just scale down?

### Mobile-Specific Considerations
- Bottom navigation bar for primary actions (thumb-friendly zone)
- Pull-to-refresh for list views
- Swipe gestures for card dismissal or navigation (with button alternatives)
- Avoid hover-dependent interactions; they do not exist on touch devices

## Interaction Design Patterns

### Forms
- Inline validation on blur, not on every keystroke
- Show validation errors below the field, not in alerts
- Mark required fields; do not mark optional ones (fewer optional fields is better)
- Group related fields; use fieldset and legend for accessibility
- Multi-step forms: show progress indicator, allow back navigation, persist state

### Modals and Overlays
- Use modals for focused tasks that require attention; not for information display
- Trap focus within the modal; return focus on close
- Allow closing via Escape key, clicking backdrop, and an explicit close button
- Do not stack modals; use drawers or inline expansion instead

### Data Display
- Tables: sortable columns, sticky headers, row actions, responsive collapse
- Lists: virtual scrolling for 100+ items, pull-to-refresh, infinite scroll with "load more" option
- Empty states: illustration + clear message + call-to-action
- Loading states: skeleton screens matching the layout of expected content

### Navigation
- Breadcrumbs for hierarchical navigation (3+ levels deep)
- Tabs for switching views within the same context
- Side navigation for applications with many sections
- Avoid mega-menus unless the information architecture demands it

## Performance Considerations
- Lazy-load routes and heavy components
- Debounce search inputs (300ms) and resize handlers
- Use `will-change` CSS property sparingly for animated elements
- Reduce DOM depth; deeply nested elements hurt rendering performance
- Measure with Lighthouse and Web Vitals; set performance budgets

## Accessibility in Design
- Design with keyboard navigation as a first-class interaction mode
- Ensure focus order follows visual reading order
- Use semantic color names (danger, warning) not just visual names (red, yellow)
- Provide text alternatives for all non-decorative visual elements
- Support user preferences: reduced motion, high contrast, font scaling
