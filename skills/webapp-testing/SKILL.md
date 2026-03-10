---
name: webapp-testing
description: "Web application testing strategies including Playwright, Cypress, component testing, visual regression, and accessibility testing."
---

# Web Application Testing

> "Testing leads to failure, and failure leads to understanding." -- Burt Rutan

## When to Use
- Setting up end-to-end (E2E) testing for web applications
- Writing or reviewing Playwright or Cypress test suites
- Implementing component testing for React, Vue, or Angular components
- Adding visual regression testing to CI/CD pipelines
- Performing accessibility (a11y) audits and automated checks
- Designing test strategies for web applications
- Debugging flaky or slow tests

## Testing Strategy Layers

### The Testing Pyramid for Web Apps
1. **Unit tests** (many, fast): Pure logic, utilities, state management, data transforms
2. **Component tests** (moderate): Render components in isolation, test interactions
3. **Integration tests** (moderate): Test connected components, API integration, routing
4. **E2E tests** (few, slow): Critical user journeys through the real application
5. **Visual regression** (targeted): Screenshot comparison for UI-heavy pages

### What to Test at Each Layer
- **Unit:** Validation logic, formatters, reducers, computed values, utility functions
- **Component:** Rendering, user interactions, conditional UI, error states, loading states
- **Integration:** Form submissions, navigation flows, authenticated routes, data fetching
- **E2E:** Sign-up flow, checkout process, critical business workflows

## Playwright

### Setup and Configuration
- Install: `npm init playwright@latest`
- Configure `playwright.config.ts` with multiple projects for cross-browser testing
- Use `webServer` config to auto-start your dev server before tests
- Set `baseURL` to avoid repeating full URLs in every test

### Writing Effective Playwright Tests
```typescript
// Use descriptive test names that explain the user journey
test('user can add item to cart and proceed to checkout', async ({ page }) => {
  await page.goto('/products');
  await page.getByRole('button', { name: 'Add to Cart' }).first().click();
  await page.getByRole('link', { name: 'Cart' }).click();
  await expect(page.getByText('1 item')).toBeVisible();
  await page.getByRole('button', { name: 'Checkout' }).click();
  await expect(page).toHaveURL(/.*checkout/);
});
```

### Playwright Best Practices
- **Use role-based locators** (`getByRole`, `getByLabel`, `getByText`) over CSS selectors
- **Use `data-testid`** only when semantic locators are insufficient
- **Avoid hard-coded waits** (`page.waitForTimeout`); use `expect` with auto-waiting
- **Use Page Object Model** for large test suites to encapsulate page interactions
- **Leverage fixtures** for authentication, database seeding, and shared setup
- **Run tests in parallel** with worker isolation (default in Playwright)
- **Use `test.step()`** for grouping related actions in a single test
- **Trace viewer:** Enable `trace: 'on-first-retry'` for debugging failures

### Playwright Advanced Features
- **API testing:** Use `request` fixture for backend API testing without a browser
- **Network interception:** `page.route()` to mock API responses or simulate errors
- **Multi-tab/window:** Use `context.newPage()` for workflows spanning multiple tabs
- **File uploads/downloads:** Built-in support via `setInputFiles` and `waitForEvent('download')`
- **Mobile emulation:** Configure viewport, user agent, and touch in project settings
- **Authentication reuse:** Save storage state to file to avoid logging in for every test

## Cypress

### Setup and Configuration
- Install: `npm install cypress --save-dev`
- Configure `cypress.config.ts` for E2E and component testing
- Use `cy.intercept()` for API mocking and network control
- Set `baseUrl` in config to simplify `cy.visit()` calls

### Cypress Best Practices
- **Never use `cy.wait(ms)`**; use `cy.intercept()` with aliases and `cy.wait('@alias')`
- **Avoid chaining assertions on detached DOM elements**; re-query after actions
- **Use `cy.session()`** for caching authentication across tests
- **Keep tests independent:** Each test should set up its own state
- **Use custom commands** for repeated actions (login, seed data)
- **Avoid conditional testing** (if element exists, then...); tests should be deterministic

### Cypress vs Playwright Decision Guide
| Factor | Playwright | Cypress |
|--------|-----------|---------|
| Multi-browser | Chromium, Firefox, WebKit | Chrome, Firefox, Edge |
| Multi-tab support | Yes | No |
| Language | JS/TS, Python, Java, C# | JS/TS only |
| Architecture | Out-of-process | In-process (same event loop) |
| Parallel execution | Built-in workers | Requires CI parallelization |
| Component testing | Experimental | Mature |
| Best for | Cross-browser E2E, CI | Developer experience, debugging |

## Component Testing

### React Component Testing
- Use **React Testing Library** (`@testing-library/react`) for component tests
- Test behavior, not implementation: query by role, text, label
- Use `userEvent` over `fireEvent` for realistic interaction simulation
- Mock API calls with MSW (Mock Service Worker) for integration-level component tests
- Test error boundaries and loading states explicitly

### Key Principles
- **Arrange-Act-Assert:** Set up, perform action, verify result
- **Test user-visible behavior:** What the user sees and does, not internal state
- **Avoid testing implementation:** Don't assert on component state or internal methods
- **Test accessibility:** Ensure components are queryable by role (means they're accessible)
- **Snapshot tests sparingly:** Only for stable, presentational components

## Visual Regression Testing

### Tools and Approaches
- **Playwright visual comparisons:** `await expect(page).toHaveScreenshot()` with threshold
- **Chromatic:** Cloud service for Storybook visual testing with review workflow
- **Percy (BrowserStack):** Cross-browser visual testing as a service
- **reg-suit / reg-cli:** Open-source visual regression with S3/GCS storage

### Implementation Guidelines
- Capture screenshots at specific viewport sizes (mobile, tablet, desktop)
- Use a consistent environment (Docker) to avoid OS-level font rendering differences
- Set appropriate thresholds (0.1-0.3%) to ignore anti-aliasing differences
- Mask dynamic content (dates, avatars, ads) before comparison
- Review visual diffs in PR workflow before merging
- Store baseline images in version control or cloud storage

## Accessibility Testing

### Automated Accessibility Checks
- **axe-core:** Integrate via `@axe-core/playwright` or `cypress-axe`
- Run `checkA11y()` on every page in E2E tests to catch regressions
- Test keyboard navigation: Tab order, focus management, escape to close
- Verify ARIA attributes: roles, labels, live regions, expanded/collapsed states

### Key Accessibility Tests
- All interactive elements are keyboard accessible
- Color contrast meets WCAG AA (4.5:1 for text, 3:1 for large text)
- Images have meaningful alt text (or empty alt for decorative)
- Forms have associated labels
- Focus is managed correctly in modals and dynamic content
- Screen reader announcements for dynamic updates (ARIA live regions)

### Manual Testing Checklist
- Navigate the entire app using only keyboard
- Test with a screen reader (VoiceOver, NVDA, JAWS)
- Zoom to 200% and verify layout doesn't break
- Test with high-contrast mode enabled
- Verify motion preferences are respected (`prefers-reduced-motion`)

## CI/CD Integration

### Pipeline Configuration
- Run unit and component tests on every PR (fast feedback)
- Run E2E tests on merge to main or on staging deployment
- Use test sharding for large E2E suites (Playwright `--shard` flag)
- Upload test artifacts (screenshots, videos, traces) on failure
- Set up test result reporting (JUnit XML, HTML reports)

### Dealing with Flaky Tests
- Quarantine flaky tests (tag and run separately) rather than disabling them
- Enable retries with `retries: 2` but investigate root causes
- Common flaky test causes: timing issues, shared state, network dependencies, animation races
- Use Playwright's `trace` and Cypress's `video` to debug intermittent failures
- Assert on stable attributes, not dynamic content or animation states

## Test Data Management
- Use factories or builders for test data (not raw fixtures)
- Seed database before tests; clean up after (or use transactions that rollback)
- Mock external services (payment, email, SMS) in E2E tests
- Use deterministic data: fixed dates, seeded random values, known user accounts
- Isolate test environments to prevent parallel test interference
