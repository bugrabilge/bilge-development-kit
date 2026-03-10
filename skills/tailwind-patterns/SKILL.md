---
name: tailwind-patterns
description: "Tailwind CSS utility patterns, responsive design, custom themes, component styling strategies, and plugin usage. Use when building UIs with Tailwind or establishing Tailwind conventions."
---

# Tailwind Patterns

> "Utility-first CSS trades premature abstraction for explicit, composable, and deletable styles."

## When to Use
- Building or styling components with Tailwind CSS
- Setting up Tailwind configuration and custom themes
- Creating reusable component patterns without custom CSS
- Implementing responsive and dark mode designs
- Reviewing Tailwind usage for consistency and performance

## Core Philosophy
- Utility-first: compose small utility classes rather than writing custom CSS
- Extract components (React, Vue, etc.) rather than creating @apply-heavy CSS classes
- Use @apply sparingly and only in base layer resets or truly global styles
- Let Tailwind's purge (content config) remove unused styles automatically

## Responsive Design

### Mobile-First Breakpoints
- Tailwind uses min-width breakpoints by default: sm, md, lg, xl, 2xl
- Write base styles for mobile, then layer on responsive modifiers
- Example: `class="text-sm md:text-base lg:text-lg"`
- Avoid max-width breakpoints unless truly needed (use `max-sm:`, `max-md:` etc.)

### Container Patterns
- Use `mx-auto max-w-7xl px-4 sm:px-6 lg:px-8` for centered page containers
- Prefer max-w constraints over the container class for more control
- Use CSS Grid with Tailwind: `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6`

### Responsive Visibility
- `hidden md:block` to hide on mobile, show on desktop
- `md:hidden` to show on mobile, hide on desktop
- Prefer responsive layout changes over hiding/showing duplicate content

## Component Patterns

### Buttons
```
<!-- Primary -->
<button class="inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">
  Button
</button>
```
- Always include focus-visible styles for keyboard accessibility
- Use disabled: modifier for disabled states
- Add transition-colors for smooth hover effects

### Cards
```
<div class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm dark:border-gray-700 dark:bg-gray-800">
  <h3 class="text-lg font-semibold text-gray-900 dark:text-white">Title</h3>
  <p class="mt-2 text-sm text-gray-600 dark:text-gray-300">Description</p>
</div>
```

### Form Inputs
```
<input class="block w-full rounded-md border border-gray-300 px-3 py-2 text-sm placeholder:text-gray-400 focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 disabled:bg-gray-50 dark:border-gray-600 dark:bg-gray-700 dark:text-white" />
```
- Always style focus, disabled, and dark mode states
- Use placeholder: modifier for placeholder styling
- Group label + input + error message with consistent spacing

### Navigation
- Use `flex items-center gap-x-6` for horizontal nav items
- Active state: `text-blue-600 font-semibold` vs inactive: `text-gray-600 hover:text-gray-900`
- Mobile nav: slide-in sidebar or full-screen overlay toggled with state

## Dark Mode

### Configuration
- Set `darkMode: 'class'` in tailwind.config for manual toggle support
- Use `darkMode: 'media'` to follow OS preference automatically
- Pair every light color with a dark variant in your component classes

### Pattern
- Apply `dark:` variants alongside base classes: `bg-white dark:bg-gray-900`
- Use semantic color tokens via CSS custom properties for easier theming
- Test dark mode for contrast compliance (4.5:1 minimum for text)

## Custom Theme Configuration

### Extending the Default Theme
```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          900: '#1e3a5f',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      },
      spacing: {
        18: '4.5rem',
        88: '22rem',
      },
    },
  },
}
```
- Extend rather than override to keep Tailwind defaults available
- Define brand colors with a full shade range (50-950)
- Use CSS custom properties for runtime theme switching

### Custom Plugins
- Use addComponents for reusable component classes
- Use addUtilities for custom utility classes
- Use addBase for global base styles (font smoothing, box-sizing)
- Leverage official plugins: @tailwindcss/typography, @tailwindcss/forms, @tailwindcss/container-queries

## Typography with @tailwindcss/typography
- Apply `prose` class to rendered Markdown or CMS content
- Customize with `prose-lg`, `prose-invert` for dark mode
- Override specific elements: `prose-headings:font-bold prose-a:text-blue-600`
- Set max-width with `prose` (default 65ch) or override with `max-w-none`

## Animation and Transitions
- Use built-in: `transition-all duration-200 ease-in-out`
- Hover effects: `hover:scale-105 transition-transform`
- Loading states: `animate-spin`, `animate-pulse`, `animate-bounce`
- Define custom animations in tailwind.config.js under theme.extend.animation and keyframes

## Performance and Organization

### Class Ordering
- Follow a consistent order: layout > sizing > spacing > typography > visual > interactive
- Use Prettier plugin (prettier-plugin-tailwindcss) to auto-sort classes
- Install and enforce via pre-commit hooks

### Avoiding Bloat
- Tailwind v3+ uses JIT by default; only used classes are generated
- Configure content paths correctly to include all template files
- Avoid dynamic class construction: `text-${color}-500` will not be purged correctly
- Use safelist in config only for truly dynamic classes

### Extracting Patterns
- Prefer extracting React/Vue components over @apply classes
- When @apply is necessary, keep it in a dedicated styles layer file
- Use CVA (class-variance-authority) or tailwind-merge for conditional class composition
- tailwind-merge resolves conflicts: `twMerge('px-4 px-6')` yields `px-6`

## Accessibility Checklist
- Use `sr-only` class for screen-reader-only text on icon buttons
- Apply `focus-visible:` instead of `focus:` for keyboard-only focus styles
- Ensure color contrast meets WCAG AA standards (use Tailwind's built-in colors which are designed for this)
- Use `motion-reduce:` variants for users who prefer reduced motion
- Add `not-sr-only` to make sr-only content visible in specific states if needed

## Common Mistakes to Avoid
- Using arbitrary values (`[123px]`) excessively; define design tokens instead
- Forgetting dark mode variants on interactive states (hover, focus)
- Nesting Tailwind classes inside @apply chains that recreate traditional CSS
- Not using the Prettier plugin, leading to inconsistent class ordering
- Overriding Tailwind defaults instead of extending them
