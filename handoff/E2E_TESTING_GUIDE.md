# E2E Testing Guide — Playwright Implementation

**For:** Kimi AI
**Date:** 2026-04-05
**Priority:** High — production readiness gate

---

## Overview

Implement comprehensive Playwright E2E tests for the MIPLG Hub web frontend. All tests must be **dynamic** — real browser interactions following user journeys, NOT static import checks.

---

## Prerequisites

### Install Playwright

```bash
cd /home/goodness/MIPLG/frontend
npm install -D @playwright/test
npx playwright install chromium
```

### Create Config

Create `frontend/playwright.config.ts`:

```typescript
import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: "html",
  use: {
    baseURL: "http://localhost:3000",
    trace: "on-first-retry",
    screenshot: "only-on-failure",
  },
  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
    {
      name: "mobile",
      use: { ...devices["iPhone 14"] },
    },
  ],
  webServer: {
    command: "npm run dev -- -p 3000",
    url: "http://localhost:3000",
    reuseExistingServer: true,
    timeout: 120_000,
  },
});
```

### Test Directory Structure

```
frontend/e2e/
├── fixtures/
│   └── auth.ts              # Shared auth helpers
├── auth/
│   ├── registration.spec.ts  # Register journey
│   ├── login.spec.ts         # Login journey
│   └── password-reset.spec.ts
├── opportunities/
│   ├── browse.spec.ts        # Browse & filter
│   ├── save.spec.ts          # Save/unsave
│   └── detail.spec.ts        # View detail
├── resources/
│   ├── browse.spec.ts
│   ├── bookmark.spec.ts
│   └── detail.spec.ts
├── mentorship/
│   ├── browse-mentors.spec.ts
│   ├── matches.spec.ts
│   └── sessions.spec.ts
├── kids/
│   ├── games.spec.ts
│   ├── worlds.spec.ts
│   └── gameplay.spec.ts
├── payments/
│   └── pricing.spec.ts
├── profile/
│   └── settings.spec.ts
├── navigation/
│   ├── mobile-nav.spec.ts
│   └── desktop-nav.spec.ts
└── theme/
    └── dark-mode.spec.ts
```

---

## Running Services (must be running before tests)

| Service | URL | Command |
|---------|-----|---------|
| **Django API** | http://localhost:8000 | `cd backend && ../venv/bin/python manage.py runserver 0.0.0.0:8000` |
| **Redis** | localhost:6379 | `redis-server --daemonize yes` |
| **Celery** | (background) | `cd backend && ../venv/bin/celery -A config worker -l info` |
| **Frontend** | http://localhost:3000 | `cd frontend && npm run dev -- -p 3000` |
| **Admin** | http://localhost:3001 | `cd admin && npm run dev -- -p 3001` |

---

## All URLs for Manual Testing

### User-Facing (Frontend — http://localhost:3000)

| Page | URL | Auth Required |
|------|-----|---------------|
| Landing/Home | http://localhost:3000/ | No |
| Login | http://localhost:3000/login | No |
| Register | http://localhost:3000/register | No |
| Forgot Password | http://localhost:3000/forgot-password | No |
| Onboarding | http://localhost:3000/onboarding | Yes |
| Opportunities List | http://localhost:3000/opportunities | No |
| Opportunity Detail | http://localhost:3000/opportunities/{slug} | No |
| Saved Opportunities | http://localhost:3000/opportunities/saved | Yes |
| Resources List | http://localhost:3000/resources | No |
| Resource Detail | http://localhost:3000/resources/{slug} | No |
| Mentors List | http://localhost:3000/mentorship | No |
| Mentor Detail | http://localhost:3000/mentorship/{id} | No |
| My Matches | http://localhost:3000/mentorship/matches | Yes |
| My Sessions | http://localhost:3000/mentorship/sessions | Yes |
| Kids Games | http://localhost:3000/kids | No |
| Kids Worlds | http://localhost:3000/kids/worlds | No |
| Kids Achievements | http://localhost:3000/kids/achievements | Yes |
| AI Chat | http://localhost:3000/ai | Yes |
| Pricing | http://localhost:3000/pricing | No |
| Profile/Settings | http://localhost:3000/settings | Yes |
| Activity Log | http://localhost:3000/activity | Yes |
| Privacy Policy | http://localhost:3000/privacy | No |
| Terms of Service | http://localhost:3000/terms | No |

### Admin Panel (http://localhost:3001)

| Page | URL | Auth Required |
|------|-----|---------------|
| Admin Login | http://localhost:3001/login | No |
| Dashboard | http://localhost:3001/ | Yes (staff) |
| User Management | http://localhost:3001/users | Yes (staff) |
| Opportunities Mgmt | http://localhost:3001/opportunities | Yes (staff) |
| Resources Mgmt | http://localhost:3001/resources | Yes (staff) |
| Partners | http://localhost:3001/partners | Yes (staff) |
| Analytics | http://localhost:3001/analytics | Yes (staff) |

### API Endpoints (http://localhost:8000)

| Page | URL |
|------|-----|
| Swagger UI | http://localhost:8000/api/docs/ |
| ReDoc | http://localhost:8000/api/redoc/ |
| OpenAPI Schema | http://localhost:8000/api/schema/ |
| Django Admin | http://localhost:8000/django-admin/ |

### Test Credentials

| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@miplg.com | admin123 |
| **Regular User** | test@miplg.com | testpass123 |

---

## Auth Fixture

Create `frontend/e2e/fixtures/auth.ts`:

```typescript
import { test as base, Page } from "@playwright/test";

type AuthFixtures = {
  authenticatedPage: Page;
  adminPage: Page;
};

export const test = base.extend<AuthFixtures>({
  authenticatedPage: async ({ page }, use) => {
    // Login via API to get token, then set in localStorage
    const response = await page.request.post(
      "http://localhost:8000/api/v1/auth/login/",
      {
        data: { email: "test@miplg.com", password: "testpass123" },
      }
    );
    const { access, refresh } = await response.json();

    await page.goto("/");
    await page.evaluate(
      ({ access, refresh }) => {
        const state = {
          state: {
            user: null,
            tokens: { access, refresh },
            isAuthenticated: true,
          },
          version: 0,
        };
        localStorage.setItem("auth-storage", JSON.stringify(state));
      },
      { access, refresh }
    );

    await page.goto("/");
    await use(page);
  },

  adminPage: async ({ page }, use) => {
    const response = await page.request.post(
      "http://localhost:8000/api/v1/auth/login/",
      {
        data: { email: "admin@miplg.com", password: "admin123" },
      }
    );
    const { access, refresh } = await response.json();

    await page.goto("http://localhost:3001");
    await page.evaluate(
      ({ access, refresh }) => {
        const state = {
          state: {
            user: null,
            tokens: { access, refresh },
            isAuthenticated: true,
          },
          version: 0,
        };
        localStorage.setItem("auth-storage", JSON.stringify(state));
      },
      { access, refresh }
    );

    await page.goto("http://localhost:3001");
    await use(page);
  },
});

export { expect } from "@playwright/test";
```

---

## Test Journeys to Implement

### Journey 1: Registration & Onboarding (Priority: CRITICAL)

**File:** `e2e/auth/registration.spec.ts`

```
1. Navigate to /register
2. Fill email, password, confirm password
3. Click Register button
4. Assert redirected to /verify-email or onboarding
5. (Mock) Enter verification code
6. Assert redirected to /onboarding
7. Step 1: Select user category (e.g., "Creative")
8. Step 2: Select IP interests (e.g., "Copyright", "Trademark")
9. Step 3: Select career stage, enter goals
10. Step 4: Select country, language
11. Click Complete
12. Assert redirected to /opportunities (main page)
```

**Key assertions:**
- Form validation errors show for empty/invalid fields
- Password mismatch shows error
- Duplicate email shows error
- Each onboarding step highlights selected options
- Progress indicator advances

### Journey 2: Login & Token Management (Priority: CRITICAL)

**File:** `e2e/auth/login.spec.ts`

```
1. Navigate to /login
2. Fill email: test@miplg.com, password: testpass123
3. Click Login
4. Assert redirected to /opportunities
5. Assert header shows user menu (not "Sign In")
6. Navigate to a protected page (/settings)
7. Assert content loads (not redirected to login)
8. Logout (if logout button exists)
9. Assert redirected to / or /login
10. Navigate to /settings again
11. Assert redirected to /login
```

**Error cases:**
- Wrong password shows error message
- Empty fields show validation
- Non-existent email shows error

### Journey 3: Browse & Save Opportunities (Priority: HIGH)

**File:** `e2e/opportunities/browse.spec.ts`

```
1. Navigate to /opportunities (anonymous)
2. Assert opportunity cards render (at least 5)
3. Assert each card shows: title, category badge, deadline
4. Use category filter → select "Grant"
5. Assert filtered results show only grants
6. Clear filter
7. Click an opportunity card
8. Assert detail page loads with: title, description, eligibility, provider
9. Assert view count increments (check API or UI indicator)
```

**File:** `e2e/opportunities/save.spec.ts` (requires auth)

```
1. Login as test user
2. Navigate to /opportunities
3. Click save/bookmark icon on first opportunity
4. Assert icon state changes (filled/active)
5. Navigate to /opportunities/saved
6. Assert the saved opportunity appears in list
7. Click unsave
8. Assert it disappears from saved list
```

### Journey 4: Resources & Bookmarks (Priority: HIGH)

**File:** `e2e/resources/browse.spec.ts`

```
1. Navigate to /resources (anonymous)
2. Assert resource cards render
3. Filter by type → "Country Guide"
4. Assert filtered results
5. Click a resource card
6. Assert detail page with: title, content, category
```

**File:** `e2e/resources/bookmark.spec.ts` (requires auth)

```
1. Login as test user
2. Navigate to /resources
3. Click bookmark on a resource
4. Assert bookmark state changes
5. Navigate to bookmarks section
6. Assert bookmarked resource appears
```

### Journey 5: Mentorship (Priority: HIGH)

**File:** `e2e/mentorship/browse-mentors.spec.ts`

```
1. Navigate to /mentorship (anonymous)
2. Assert mentor cards render (at least 3)
3. Assert each card shows: name, category, expertise
4. Click a mentor card
5. Assert detail page loads with: bio, expertise areas, availability
```

**File:** `e2e/mentorship/matches.spec.ts` (requires auth)

```
1. Login as test user
2. Navigate to /mentorship
3. Click "Request Mentor" on a mentor card
4. Fill in message
5. Submit request
6. Navigate to /mentorship/matches
7. Assert match appears with PENDING status
```

### Journey 6: Kids Games (Priority: MEDIUM)

**File:** `e2e/kids/games.spec.ts`

```
1. Navigate to /kids (anonymous)
2. Assert game cards render (at least 3)
3. Click a game card (e.g., "Is It Yours?")
4. Assert game detail/scenarios load
5. Click "Play" or first scenario
6. Assert scenario text, answer options appear
7. Select an answer
8. Assert feedback (correct/wrong) shows
9. Complete a few scenarios
10. Assert progress updates
```

**File:** `e2e/kids/worlds.spec.ts`

```
1. Navigate to /kids/worlds
2. Assert world cards render (5 worlds)
3. Assert each shows: name, description, game count
4. Click a world card
5. Assert world detail with games listed
```

### Journey 7: Pricing Page (Priority: MEDIUM)

**File:** `e2e/payments/pricing.spec.ts`

```
1. Navigate to /pricing (anonymous)
2. Assert 3 plan cards render (Free, Premium Monthly, Premium Annual)
3. Assert feature lists on each card
4. Assert Premium Monthly shows NGN 4,999
5. Assert Premium Annual shows NGN 39,999
6. Click "Subscribe" on a premium plan
7. Assert redirected to /login (if not authenticated)
8. Login, return to /pricing
9. Click "Subscribe" again
10. Assert Paystack checkout initiates (or redirect to payment)
```

### Journey 8: Profile & Settings (Priority: MEDIUM)

**File:** `e2e/profile/settings.spec.ts` (requires auth)

```
1. Login as test user
2. Navigate to /settings
3. Assert profile form shows current data
4. Update first name, last name
5. Save
6. Assert success toast/notification
7. Refresh page
8. Assert updated values persist
```

### Journey 9: Navigation & Responsive (Priority: MEDIUM)

**File:** `e2e/navigation/mobile-nav.spec.ts`

```
1. Set viewport to mobile (375x667)
2. Navigate to /
3. Assert bottom tab bar is visible
4. Tap each tab → assert correct page loads
5. Assert top hamburger menu opens
6. Assert sidebar/drawer appears with links
```

**File:** `e2e/navigation/desktop-nav.spec.ts`

```
1. Set viewport to desktop (1440x900)
2. Navigate to /
3. Assert top navbar with all links visible
4. Assert sidebar (if dashboard layout)
5. Click each nav link → assert correct page
```

### Journey 10: Dark Mode (Priority: LOW)

**File:** `e2e/theme/dark-mode.spec.ts`

```
1. Navigate to /
2. Assert light mode is default (check body/html class)
3. Click theme toggle
4. Assert dark mode class applied
5. Navigate to another page
6. Assert dark mode persists
7. Toggle back
8. Assert light mode restored
```

### Journey 11: Admin Panel (Priority: HIGH)

**File:** `e2e/admin/dashboard.spec.ts` (use adminPage fixture, baseURL: http://localhost:3001)

```
1. Login as admin
2. Navigate to admin dashboard
3. Assert stats cards render (users, opportunities, resources, etc.)
4. Navigate to /users
5. Assert user table renders
6. Search for "test@miplg.com"
7. Assert user appears
8. Navigate to /opportunities
9. Assert opportunity management table renders
```

---

## Implementation Rules

1. **Every test follows user journey pattern** — simulate what a real user does
2. **No static import checks** — every test must interact with real UI elements
3. **Use `data-testid` attributes** if needed — add them to components
4. **Mobile-first** — test mobile viewport for every critical journey
5. **Screenshots on failure** — configured via `screenshot: "only-on-failure"`
6. **Max 300 lines per test file** — split into focused files
7. **Run with:** `npx playwright test`
8. **Debug with:** `npx playwright test --headed --debug`
9. **View report:** `npx playwright show-report`

---

## CSS Selectors Guide

Since the app uses CSS Modules, class names are hashed. Use these strategies:

| Strategy | Example |
|----------|---------|
| **Text content** | `page.getByText("Opportunities")` |
| **Role** | `page.getByRole("button", { name: "Save" })` |
| **Placeholder** | `page.getByPlaceholder("Search...")` |
| **Label** | `page.getByLabel("Email")` |
| **Test ID** | `page.getByTestId("opportunity-card")` |
| **Link** | `page.getByRole("link", { name: "Login" })` |
| **Heading** | `page.getByRole("heading", { name: "Opportunities" })` |

Avoid using CSS class selectors — they'll break with CSS Modules hashing.

---

## Seeded Data Available

The following data exists in the database for testing:

| Data | Count | Notes |
|------|-------|-------|
| Opportunities | 15 | Mix of grants, fellowships, scholarships, jobs, certifications |
| Resources | 17 | Country guides, how-tos, creative guides, checklists |
| Mentors | 8 | IP lawyers, creatives, founders, policy experts |
| Subscription Plans | 3 | Free, Premium Monthly (NGN 4,999), Premium Annual (NGN 39,999) |
| Game Worlds | 5 | Creativity Island, Copyright Castle, Patent Peak, Trademark Town, Heritage Valley |
| Games | 6 | Is It Yours, Copyright Quest, Patent Protector, Trademark Detective, Heritage Explorer, Protect It |
| Scenarios | 41 | Across all 6 games |
| Achievements | 13 | Various categories |

---

## Running Tests

```bash
# Run all tests
cd /home/goodness/MIPLG/frontend
npx playwright test

# Run specific test file
npx playwright test e2e/auth/login.spec.ts

# Run with visible browser
npx playwright test --headed

# Run mobile tests only
npx playwright test --project=mobile

# Debug mode (step through)
npx playwright test --debug

# Generate HTML report
npx playwright test --reporter=html
npx playwright show-report
```

---

## Definition of Done

- [ ] All 11 journeys implemented as Playwright specs
- [ ] All tests pass on both `chromium` and `mobile` projects
- [ ] Screenshots captured on failure
- [ ] `data-testid` attributes added to components where needed
- [ ] Tests run in < 60 seconds total
- [ ] HTML report generated and reviewed
- [ ] Any UI bugs found during testing are documented (file + line)
