---
user-invocable: false
name: web-design-guidelines
description: "Responsive design, accessibility (WCAG), layout principles, cross-browser compatibility, and web performance. Use when designing or reviewing web interfaces for usability, compliance, and consistency."
---

# Web Design Guidelines

> "The web is for everyone; design with inclusivity, clarity, and resilience as your compass."

## When to Use
- Designing responsive web layouts
- Auditing sites for WCAG accessibility compliance
- Reviewing cross-browser compatibility issues
- Establishing design system foundations
- Optimizing web performance and Core Web Vitals
- Creating mobile-first or adaptive interfaces

## Responsive Design

### Mobile-First Approach
- Start with the smallest viewport and enhance upward
- Base styles serve mobile; use min-width media queries to add complexity
- Touch targets must be at least 44x44 CSS pixels (WCAG 2.5.5)
- Test at 320px, 375px, 768px, 1024px, 1440px breakpoints

### Fluid Layouts
- Use relative units (%, vw, rem) instead of fixed px for widths
- Use clamp() for fluid typography: `font-size: clamp(1rem, 2.5vw, 2rem)`
- Set max-width on content containers (typically 1200-1440px) to prevent ultra-wide stretching
- Use CSS Grid for two-dimensional layouts; Flexbox for one-dimensional alignment

### Breakpoint Strategy
- Define breakpoints based on content, not device names
- Common system: sm (640px), md (768px), lg (1024px), xl (1280px), 2xl (1536px)
- Avoid more than 4-5 breakpoints; complexity grows quickly
- Test between breakpoints, not just at them

### Images and Media
- Use srcset and sizes for responsive images
- Serve WebP/AVIF with fallback to JPEG/PNG
- Set explicit width and height attributes to prevent layout shift
- Use aspect-ratio CSS property for responsive video/embed containers

## Accessibility (WCAG 2.1 AA)

### Perceivable
- Color contrast ratio: 4.5:1 for normal text, 3:1 for large text (18px+ bold or 24px+)
- Never rely on color alone to convey information; use icons, patterns, or text alongside
- Provide alt text for informational images; use alt="" for decorative images
- Captions for video; transcripts for audio content
- Ensure text can be resized to 200% without loss of content or functionality

### Operable
- All functionality available via keyboard
- No keyboard traps; users can always Tab or Escape out
- Provide skip navigation links for screen reader users
- Avoid content that flashes more than 3 times per second
- Give users enough time to read and act; avoid auto-advancing carousels without pause controls

### Understandable
- Use clear, simple language; aim for 8th-grade reading level for general audiences
- Label form inputs explicitly with `<label for="...">` or aria-labelledby
- Provide error messages that describe what went wrong and how to fix it
- Consistent navigation across pages; same elements in the same order
- Identify the page language with `<html lang="en">`

### Robust
- Use valid, semantic HTML; validate with W3C validator
- Test with assistive technologies: screen readers, voice control, magnifiers
- Ensure custom widgets implement correct ARIA roles, states, and properties
- Progressive enhancement: core functionality works without JavaScript

## Layout Principles

### Visual Hierarchy
- Use size, weight, color, and spacing to guide the eye
- Primary actions should be visually dominant (larger, higher contrast)
- Group related content using proximity and consistent spacing
- Use whitespace generously; crowded layouts reduce comprehension

### Typography
- Limit to 2-3 font families maximum (one serif, one sans-serif, one mono if needed)
- Body text: 16px minimum, line-height 1.5-1.75 for readability
- Heading scale: use a consistent ratio (e.g., 1.25 or 1.333 modular scale)
- Line length: 45-75 characters per line for optimal readability
- Ensure sufficient contrast between text and background

### Spacing System
- Use a consistent spacing scale (e.g., 4px base: 4, 8, 12, 16, 24, 32, 48, 64)
- Apply spacing consistently: same gap between similar elements
- Use margin for spacing between components; padding for spacing within components
- CSS custom properties for spacing tokens: `--space-sm: 0.5rem; --space-md: 1rem;`

### Color System
- Define a palette with primary, secondary, neutral, and semantic colors (success, warning, error)
- Each color needs light and dark variants (at least 5-7 shades)
- Test palette against WCAG contrast requirements
- Provide a dark mode that is designed, not just inverted
- Use CSS custom properties for theming: `--color-primary: hsl(220, 90%, 56%)`

## Cross-Browser Compatibility

### Testing Matrix
- Test on latest versions of Chrome, Firefox, Safari, and Edge
- Test on iOS Safari and Android Chrome for mobile
- Use caniuse.com to check feature support before adopting new CSS/JS features
- Set up automated cross-browser testing with BrowserStack or Playwright

### Progressive Enhancement
- Core content and functionality must work without CSS or JS
- Use feature queries (`@supports`) to apply modern CSS only where supported
- Provide fallbacks for CSS Grid (Flexbox), container queries, and newer features
- Test with JavaScript disabled for critical content pages

### Common Pitfalls
- Safari has different behavior for `position: sticky`, `gap` in Flexbox (older versions), and date inputs
- Firefox handles `scrollbar-width` differently; use both standard and webkit-prefixed
- Avoid vendor prefixes manually; use Autoprefixer via PostCSS
- Test form elements across browsers; native styling varies significantly

## Web Performance

### Core Web Vitals
- LCP (Largest Contentful Paint): under 2.5 seconds; preload hero images and fonts
- FID/INP (Interaction to Next Paint): under 200ms; minimize main thread blocking
- CLS (Cumulative Layout Shift): under 0.1; reserve space for images, ads, and dynamic content

### Loading Strategy
- Critical CSS inlined in `<head>`; non-critical CSS loaded asynchronously
- Defer non-essential JavaScript with `defer` or `async` attributes
- Lazy-load below-the-fold images and iframes
- Use resource hints: `<link rel="preconnect">` for API domains, `<link rel="preload">` for critical assets

### Font Loading
- Use `font-display: swap` to prevent invisible text during font loading
- Subset fonts to include only needed character sets
- Self-host fonts for reliability and performance; avoid multiple Google Font requests
- Preload the primary font file: `<link rel="preload" as="font" crossorigin>`

### Caching
- Set long Cache-Control max-age for versioned static assets (JS, CSS, images)
- Use content hashing in filenames for cache busting
- Configure service workers for offline-first experiences where appropriate

## Design System Foundations
- Document spacing, color, typography, and component tokens
- Use design tokens (JSON or CSS custom properties) as the single source of truth
- Ensure every component in the system meets accessibility requirements
- Version the design system; treat it as a dependency with a changelog
- Provide usage guidelines alongside component code: when to use, when not to use
