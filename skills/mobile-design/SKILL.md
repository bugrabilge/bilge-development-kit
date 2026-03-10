---
name: mobile-design
description: "Mobile UI/UX patterns, platform-specific guidelines (iOS HIG, Material Design), gesture interactions, and navigation patterns for mobile apps."
---

# Mobile Design

> "Mobile is not a small screen experience. It is a one-hand, one-eye, on-the-go experience." -- Luke Wroblewski

## When to Use
- Designing user interfaces for iOS and Android applications
- Implementing platform-specific design patterns (iOS HIG, Material Design)
- Choosing navigation patterns for mobile apps
- Designing touch interactions and gesture-based interfaces
- Creating responsive and adaptive layouts for different screen sizes
- Reviewing mobile designs for usability and platform consistency
- Building cross-platform apps that feel native on each platform

## Platform Design Languages

### iOS Human Interface Guidelines (HIG)
Apple's design philosophy emphasizes clarity, deference, and depth.

**Core Principles:**
- **Clarity:** Text is legible, icons are precise, adornments are subtle and appropriate
- **Deference:** The UI helps users understand and interact with content without competing with it
- **Depth:** Visual layers and realistic motion create hierarchy and spatial relationships

**iOS-Specific Patterns:**
- Navigation bars at the top with back chevron (not arrow)
- Tab bars at the bottom with icon + label (max 5 tabs)
- Large titles that collapse on scroll (UINavigationBar large title mode)
- Sheet presentations (half-sheet, full-sheet) for secondary content
- Swipe-to-go-back gesture from left edge
- SF Symbols for consistent, scalable iconography
- Dynamic Type for user-controlled text sizes
- Haptic feedback (UIFeedbackGenerator) for tactile responses

**iOS Typography:**
- System font: San Francisco (SF Pro for UI, SF Mono for code)
- Support Dynamic Type with all custom text styles
- Minimum body text: 17pt for readability
- Use text styles (Title, Headline, Body, Caption) for consistency

### Material Design (Google / Android)
Google's design system emphasizes adaptive, accessible, and expressive interfaces.

**Core Principles:**
- **Adaptive:** Design that scales across devices, input modes, and screen sizes
- **Accessible:** Built-in accessibility with meaningful color, typography, and motion
- **Expressive:** Customizable theming with Material You dynamic color

**Material Design Patterns:**
- Top app bar with title and action icons
- Navigation rail (tablet) or bottom navigation bar (phone)
- Floating action button (FAB) for primary action
- Navigation drawer for extensive navigation (hamburger menu)
- Bottom sheets for supplementary content and actions
- Snackbar for brief feedback messages
- Chips for filters, tags, and compact actions
- Material You dynamic color theming from wallpaper

**Material Typography:**
- Roboto as the default system font
- Type scale: Display, Headline, Title, Body, Label
- Minimum body text: 14sp for readability
- Use sp (scalable pixels) to respect user font preferences

## Navigation Patterns

### Tab Navigation (Bottom Tabs)
Best for: 3-5 top-level destinations of equal importance
- Each tab maintains its own navigation stack
- Show labels with icons (icon-only is harder to understand)
- Highlight the active tab clearly
- iOS: Use a tab bar; Android: Use bottom navigation
- Don't use more than 5 tabs; use a "More" tab if needed

### Stack Navigation
Best for: Hierarchical content (list to detail)
- Push new screens onto the stack; back button pops them
- Show a back button or allow swipe-back gesture
- Title reflects current screen content
- Avoid deep stacks (more than 4-5 levels); reconsider information architecture

### Drawer Navigation
Best for: Many navigation destinations (6+) or secondary navigation
- Common on Android (navigation drawer), less common on iOS
- Don't hide primary navigation in a drawer on iOS; use tabs instead
- Show the current section as highlighted in the drawer
- Can combine with bottom tabs (tabs for primary, drawer for secondary)

### Modal Navigation
Best for: Focused tasks that interrupt the main flow
- Full-screen modals for complex tasks (compose email, create post)
- Half-sheet modals for quick actions (share, filter, sort)
- Always provide a clear dismiss action (close button, swipe down)
- Prevent accidental dismissal of unsaved work (confirmation dialog)

## Touch Interaction Design

### Touch Targets
- **Minimum size:** 44x44pt (iOS) / 48x48dp (Android)
- **Spacing:** At least 8pt/8dp between adjacent touch targets
- **Thumb zone:** Place primary actions in the bottom half of the screen (easy thumb reach)
- **Unreachable areas:** Top corners are hardest to reach on large phones

### Gesture Design
- **Tap:** Primary interaction; select, toggle, navigate
- **Long press:** Secondary actions, context menus, drag initiation
- **Swipe horizontal:** Delete (iOS swipe actions), navigate between tabs/pages
- **Swipe vertical:** Scroll, pull-to-refresh, dismiss sheets
- **Pinch:** Zoom in/out on images, maps, content
- **Double tap:** Quick zoom, like/favorite

### Gesture Best Practices
- Always provide a visible alternative to gesture-based actions
- Don't require multi-finger gestures for essential functions
- Use standard platform gestures (don't invent new ones unnecessarily)
- Provide haptic feedback for important gesture completions
- Animate content to follow the user's finger (direct manipulation)
- Support gesture cancellation (drag back to original position to cancel)

## Layout and Responsive Design

### Screen Size Adaptation
- **Compact width** (phones portrait): Single-column layout
- **Medium width** (phones landscape, small tablets): Optional two-column
- **Expanded width** (tablets, foldables): Multi-pane layout (list-detail)
- Use iOS Size Classes or Android Window Size Classes for adaptive layouts

### Safe Areas
- Respect the safe area insets (notch, home indicator, status bar)
- Don't place interactive elements behind system UI
- On iOS: use `safeAreaInset`; on Android: use `WindowInsetsCompat`
- Account for rounded corners on modern devices
- Handle landscape orientation safe areas (notch on side)

### Spacing and Grid
- Use consistent spacing values: 4, 8, 12, 16, 24, 32, 48pt/dp
- Maintain 16pt/16dp horizontal margins on phone layouts
- Use a responsive grid that adapts to screen width
- Content should breathe: don't pack elements too tightly

## Common UI Components

### Lists
- Standard list items: 44-48pt height minimum for touch targets
- Use section headers for grouped lists
- Support swipe actions for quick operations (delete, archive, pin)
- Show loading states (skeleton screens) while fetching data
- Implement pull-to-refresh for updatable lists
- Use pagination or infinite scroll for long lists (with loading indicators)

### Forms
- Use appropriate keyboard types (email, number, phone, URL)
- Show validation errors inline, not in alerts
- Auto-advance between fields when possible
- Position submit buttons in thumb-reachable zones
- Support autofill and password managers
- Avoid dropdowns for few options (use segmented controls or radio buttons)
- Show clear labels above inputs, not just placeholder text

### Empty States
- Show helpful messaging when lists are empty
- Provide a clear action to populate the empty state
- Use illustrations to make empty states feel designed, not broken
- Differentiate between "no data yet" and "no results found"

### Loading States
- Use skeleton screens instead of spinners for content loading
- Show progress indicators for deterministic operations
- Use optimistic UI updates where safe (mark as read, like)
- Never block the entire screen with a loading indicator if partial content is available

## Accessibility on Mobile

### Essential Requirements
- Support Dynamic Type / font scaling (test at largest sizes)
- Ensure sufficient color contrast (4.5:1 minimum)
- Provide labels for all interactive elements (VoiceOver/TalkBack)
- Support Switch Control and keyboard navigation
- Test with screen readers on both platforms
- Respect reduced motion preferences
- Support dark mode with appropriate contrast

### Accessibility Testing
- iOS: Turn on VoiceOver and navigate your entire app
- Android: Turn on TalkBack and navigate your entire app
- Test with text size set to maximum
- Test with bold text enabled
- Verify that all images have descriptions (or are marked decorative)
- Ensure custom components announce their role and state

## Cross-Platform Considerations

### When to Go Native vs Cross-Platform
- **Native (Swift/Kotlin):** Maximum platform fidelity, performance, and access to latest APIs
- **React Native:** Shared business logic with native UI, large ecosystem
- **Flutter:** Pixel-perfect custom UI across platforms, single codebase
- **Expo:** React Native with managed workflow, simpler builds and updates

### Platform Adaptation in Cross-Platform Apps
- Use platform-specific navigation patterns (tabs at bottom on both, but style differs)
- Adapt icons to match platform conventions (SF Symbols on iOS, Material Icons on Android)
- Use platform-appropriate dialogs and action sheets
- Respect platform back behavior (Android hardware back button)
- Match platform typography defaults and spacing conventions
- Don't force one platform's patterns onto the other
