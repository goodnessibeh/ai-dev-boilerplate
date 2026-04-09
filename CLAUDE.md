# [Project Name] — Engineering Standards

> This file governs ALL code written in this project. Every session, every agent, every tool call must comply.
> **This is the central reference document.** All agents and sessions start here.

---

## BOILERPLATE ADAPTATION INSTRUCTIONS

> **For any AI model working on this project:** This file was created from a boilerplate template. As the project grows, you MUST continuously adapt this document to reflect the actual project:

1. **Replace all `[Project Name]` placeholders** with the real project name on first use
2. **Replace all `[Your Name]` / `[your@email.com]`** with the actual developer's identity
3. **Update the "Design Reference UI Kits" table** with the actual UI kits being used (or remove if not applicable)
4. **Update the "Exemptions to the 300-Line Limit" table** with paths specific to this project
5. **Add project-specific enum values** to `docs/contracts/_enums.contract.ts` as new features are built
6. **Create feature contracts** in `docs/contracts/{module}.contract.ts` as new modules are implemented
7. **Update `handoff/SESSION_MEMORY.md`** with locked architecture decisions, module status, and session history
8. **Add project-specific sections** (e.g., Mobile App Implementation, specific payment provider details, deployment instructions) as the project evolves
9. **Remove sections that don't apply** — if no mobile app, remove the Mobile section; if not using Django, adapt the backend patterns
10. **Keep this BOILERPLATE ADAPTATION section** until all placeholders are replaced and the document is fully adapted, then remove it

**This document should be a living, accurate reflection of the project at all times — not a stale template.**

---

## Project References

All agents, subagents, and sessions MUST consult these documents before implementation:

| Document | Path | When to Read |
|----------|------|-------------|
| **Technical PRD** | `docs/TECHNICAL_PRD.md` | Before implementing any feature — contains all models, APIs, architecture |
| **Build Plan** | `docs/BUILD_PLAN.md` | Before starting any sprint — contains phased timeline and task checklists |
| **Session Memory** | `handoff/SESSION_MEMORY.md` | At the START of every session — contains all decisions, module status, history |
| **Latest Handoff** | `handoff/SESSION_NNN_*.md` | At the START of every session — contains what was done last and what comes next |
| **Handoff Template** | `handoff/HANDOFF_TEMPLATE.md` | At the END of every session — use to write the new handoff |
| **Agent Coordination** | `docs/AGENT_COORDINATION.md` | Before ANY multi-agent work — contracts, enums, naming, migrations |
| **Enum Contract** | `docs/contracts/_enums.contract.ts` | Before using ANY enum — single source of truth for all enum values |
| **Feature Contracts** | `docs/contracts/{module}.contract.ts` | Before implementing ANY endpoint — defines exact request/response shapes |

### Skills & Agents (consult before implementation)

| Resource | Path | When to Consult |
|----------|------|----------------|
| Senior Security | `.claude/skills/senior-security/` | Auth, payments, file uploads, any user-facing endpoint |
| Database Optimizer | `.claude/agents/database-optimizer.md` | Model design, queries, indexes, migrations |
| Frontend Design | `.claude/skills/frontend-design/` | UI components, layouts, interactions |
| Web Performance | `.claude/skills/web-perf/` | Page load, bundle size, rendering performance |
| QA Testing | `.claude/skills/qa-testing/` | Test strategy, test writing, coverage |
| TDD | `.claude/skills/test-driven-development/` | TDD workflow, test-first approach |
| Security Code Review | `.claude/skills/security-code-review/` | Code review for vulnerabilities |
| Context Engineering | `.claude/skills/context-engineering/` | AI agent prompt design, context optimization |
| Product Manager Toolkit | `.claude/skills/product-manager-toolkit/` | PRD creation, feature prioritization |
| All Software Skills | `.claude/skills/01-Software-Web-Development/` | Framework-specific guidance |
| All AI Skills | `.claude/skills/02-Context-Engineering-AI/` | AI/ML implementation guidance |
| All Security Skills | `.claude/skills/03-Security/` | Security patterns and reviews |
| All QA Skills | `.claude/skills/04-QA-Testing/` | Testing strategies |
| All Commands | `.claude/commands/` | `ultra-think`, `create-prd`, `init-project`, `setup-development-environment` |

### Agent Workflow

```
1.  Read CLAUDE.md (this file) — understand standards
2.  Read handoff/SESSION_MEMORY.md — understand project state
3.  Read latest handoff/SESSION_NNN_*.md — understand what comes next
4.  Read docs/TECHNICAL_PRD.md — understand the feature being built
5.  Read docs/BUILD_PLAN.md — understand the current sprint tasks
6.  Read docs/AGENT_COORDINATION.md — understand contracts, naming, enums
7.  Read docs/contracts/_enums.contract.ts — enum values for the feature
8.  Read docs/contracts/{module}.contract.ts — exact API contract for the feature
9.  Consult relevant .claude/skills/ — before writing any code
10. Implement with TDD + SDD (contract-first, test-first, security-first)
11. Validate against contract (integration checklist from AGENT_COORDINATION.md)
12. Write handoff at session end
```

### Naming Conventions (enforced everywhere)

| Thing | Convention | Example |
|-------|-----------|---------|
| Enum values | `UPPER_SNAKE_CASE` | `CERTIFICATION`, `SMART_MATCH` |
| Enum names | `PascalCase` | `OpportunityCategory` |
| Field names (everywhere) | `snake_case` | `created_at`, `ip_areas` |
| URL paths | kebab-case | `/api/v1/resources/saved/` |
| Python files | `snake_case` | `resource_list.py` |
| TS/TSX files | `PascalCase` (components), `camelCase` (hooks/services) | `ResourceCard.tsx`, `useResources.ts` |
| React components | `PascalCase` | `ResourceCard` |
| CSS | Tailwind utility classes | `flex items-center gap-2` |

### Git Commit Rules

- **Author:** All commits attributed to `[Your Name] <your@email.com>`
- **No AI references:** Never include "Claude", "Kimi", "AI-generated", "Co-Authored-By" or similar in commit messages
- **Commit format:** Clear, descriptive messages explaining what was done
- **No force push** to main without explicit approval
- **Always `git add .` from project root** — never add individual files, always stage everything from root to catch all changes across backend/frontend/admin/mobile
- **Use `IF NOT EXISTS`** for database column additions in migrations to avoid errors on re-run

> **See `docs/AGENT_COORDINATION.md` for the complete contract system, enum master list, migration protocol, and integration validation checklist.**

---

## Development Methodology

### Test-Driven Development (TDD)
1. **Write the test first** — before any implementation code
2. **Red** — test fails (expected, no implementation yet)
3. **Green** — write minimum code to make the test pass
4. **Refactor** — clean up while keeping tests green
5. Every endpoint, model, service, and utility must have corresponding tests
6. No feature is complete until tests pass

### Dynamic Testing Mandate

**All tests must be dynamic — exercising real running code, not static analysis of imports or types.**

Every test must follow a **user journey** — simulating what a real user or API consumer does.

| Test Layer | Tool | What It Tests | Example |
|-----------|------|---------------|---------|
| **Backend API** | `pytest` + DRF `APIClient` | Real HTTP requests against Django test server. Send request, assert response status, body, headers. | `client.post("/api/v1/auth/register/", data)` → assert 201, verify user exists in DB |
| **Backend Services** | `pytest` | Call service functions with real DB operations (factory-created data). Assert DB state changes. | `create_resource()` → assert record in DB, fields match |
| **Frontend UI** | Playwright | Real browser interactions. Click buttons, fill forms, navigate pages, assert visible elements. | Open login page → type email → type password → click submit → assert redirected to dashboard |
| **Frontend API** | Playwright + MSW or real API | Verify frontend makes correct API calls and renders responses. Test loading states, error states. | Mock API returns resources → assert cards render with correct titles |
| **Mobile** | Detox (or Maestro) | Real device/emulator interactions. Tap, swipe, type, assert screen content. | Tap "Resources" tab → assert list renders → tap first item → assert detail screen |
| **Security (DAST)** | ZAP (OWASP ZAP) / Nuclei | Real HTTP attacks against running API. SQL injection, XSS, auth bypass, header checks. | Run ZAP active scan against `/api/v1/` → assert zero high-severity findings |
| **Integration** | pytest + real DB + real Redis | End-to-end flows across services. Auth → create resource → query → assert. | Register → login → create resource → search → assert found |

### What Is NOT Acceptable As a Test

- Importing a module and checking it exists — **not a test**
- Checking that a serializer class has certain fields — **not a test** (test via API request)
- Asserting a URL resolves — **not a test** (test via HTTP request)
- Snapshot tests that only check render output didn't change — **not sufficient alone**
- Any test that doesn't involve running code with real/mocked I/O

### DAST Tools

Run DAST scans against the running API during CI and before marking security-sensitive features complete:

```bash
# OWASP ZAP (baseline scan)
docker run -t zaproxy/zap-stable zap-baseline.py -t http://localhost:8000/api/v1/

# Nuclei (vulnerability templates)
nuclei -u http://localhost:8000 -t cves/ -t vulnerabilities/

# Custom security test suite (pytest)
pytest backend/apps/*/tests/test_security/ -v
```

### User Journey Test Pattern

Every test file should follow the user journey pattern:

```python
# Backend: test a user journey, not an isolated unit
class TestResourceSaveJourney:
    """User discovers, views, and saves a resource."""

    def test_anonymous_can_browse_resources(self, api_client):
        # Setup: create resources via factory
        # Act: GET /api/v1/resources/
        # Assert: 200, data contains resources

    def test_anonymous_cannot_save_resource(self, api_client):
        # Act: POST /api/v1/resources/{id}/save/ without auth
        # Assert: 401

    def test_authenticated_user_saves_resource(self, auth_client):
        # Act: POST /api/v1/resources/{id}/save/
        # Assert: 200, saved=true
        # Verify: GET /api/v1/resources/saved/ includes it

    def test_user_unsaves_resource(self, auth_client):
        # Setup: save a resource
        # Act: POST /api/v1/resources/{id}/save/ again (toggle)
        # Assert: 200, saved=false
        # Verify: GET /api/v1/resources/saved/ excludes it
```

```typescript
// Frontend: Playwright user journey
test.describe("Resource Save Journey", () => {
  test("user browses and saves a resource", async ({ page }) => {
    // Login
    await page.goto("/login");
    await page.fill("[name=email]", "test@example.com");
    await page.fill("[name=password]", "password123");
    await page.click("button[type=submit]");
    await expect(page).toHaveURL("/resources");

    // Browse
    await expect(page.locator(".resource-card")).toHaveCount(5);

    // Save
    await page.locator(".resource-card").first().locator(".save-btn").click();
    await expect(page.locator(".save-btn").first()).toHaveAttribute("data-saved", "true");

    // Verify in saved list
    await page.goto("/resources/saved");
    await expect(page.locator(".resource-card")).toHaveCount(1);
  });
});
```

### Security-Driven Development (SDD)
1. **Threat model first** — before implementing any feature, identify attack surfaces
2. **Validate all inputs** at system boundaries (API endpoints, form submissions, file uploads)
3. **Consult the `senior-security` skill** (`/.claude/skills/senior-security/`) before implementing auth, payments, file handling, or any user-facing endpoint
4. **Run the `security_auditor.py` script** on completed features
5. Apply OWASP Top 10 protections by default
6. Never trust client input. Never expose stack traces. Never log secrets.

---

## Code Architecture Rules

### No God Files
- **No single file may exceed 300 lines**
- This is a hard limit. Do NOT compact code, remove whitespace, shorten variable names, or collapse logic to meet this limit
- If a file approaches 300 lines, **split it into logical submodules**
- Code must remain readable, well-spaced, and properly documented

#### Exemptions to the 300-Line Limit

The following file types are **exempt** from the 300-line limit (customize per project):

| File Type | Path Pattern | Reason |
|-----------|--------------|--------|
| **AI Agent Tools** | `backend/apps/ai_assistant/services/tools/*.py` | Tools need comprehensive descriptions, examples, error handling |
| **Tool Definitions** | `backend/apps/ai_assistant/services/agents/*.py` | Agent definitions with detailed instructions and tool bindings |
| **Orchestrators** | `backend/apps/ai_assistant/services/*_orchestrator.py` | Orchestrators with sub-agent coordination logic |

**For exempt files:**
- Still use directory-based organization when logical
- Still split if the file exceeds 500 lines
- Prioritize readability over line count
- Document complex logic thoroughly

### Directory-Based Module Structure
Every Django app and every API resource lives in its own directory with explicit imports. No monolithic `views.py`, `serializers.py`, or `urls.py` files.

**Backend app structure (every app follows this):**
```
backend/apps/{app_name}/
├── __init__.py
├── models/
│   ├── __init__.py              # from .model_name import ModelName (etc.)
│   ├── model_name.py            # Model definition
│   └── related_model.py         # Related model
├── serializers/
│   ├── __init__.py
│   ├── model_name.py
│   └── related_model.py
├── views/
│   ├── __init__.py
│   ├── model_list.py            # ListView
│   ├── model_detail.py          # DetailView
│   └── model_action.py          # Custom action views
├── services/
│   ├── __init__.py
│   └── business_logic.py        # Business logic separated from views
├── filters/
│   ├── __init__.py
│   └── model_filters.py
├── permissions/
│   ├── __init__.py
│   └── model_permissions.py
├── urls/
│   ├── __init__.py              # Combines all URL patterns
│   └── model_urls.py            # /api/v1/{resource}/...
├── tasks/
│   ├── __init__.py
│   └── async_tasks.py
├── tests/
│   ├── __init__.py
│   ├── test_models/
│   │   ├── __init__.py
│   │   └── test_model_name.py
│   ├── test_views/
│   │   ├── __init__.py
│   │   └── test_model_list.py
│   ├── test_services/
│   │   ├── __init__.py
│   │   └── test_business_logic.py
│   └── factories.py             # factory_boy factories
├── admin.py
└── apps.py
```

**Frontend structure (Next.js App Router + feature directories):**
```
frontend/
├── app/                         # Next.js App Router
│   ├── (auth)/                  # Auth route group (login, register, onboarding)
│   ├── (main)/                  # Main app route group
│   │   ├── {feature}/
│   │   │   ├── page.tsx         # List page (server component)
│   │   │   └── [slug]/
│   │   │       └── page.tsx     # Detail page
│   │   └── ...
│   ├── layout.tsx               # Root layout (ThemeProvider, AuthProvider)
│   └── globals.css              # Tailwind + shadcn CSS variables
├── components/
│   ├── ui/                      # shadcn/ui components (auto-generated)
│   ├── layout/
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   ├── Footer.tsx
│   │   └── ThemeToggle.tsx      # Light/dark mode toggle
│   └── shared/
│       ├── LoadingSpinner.tsx
│       ├── ErrorBoundary.tsx
│       └── EmptyState.tsx
├── features/
│   ├── {feature}/
│   │   ├── components/
│   │   │   ├── FeatureCard.tsx
│   │   │   └── FeatureFilters.tsx
│   │   ├── hooks/
│   │   │   └── useFeature.ts
│   │   ├── services/
│   │   │   └── featureApi.ts
│   │   └── types/
│   │       └── feature.ts
│   └── ...
├── providers/                   # ThemeProvider, AuthProvider, QueryProvider
├── lib/                         # shadcn utils, cn() helper
└── store/                       # Zustand stores
```

### Import Rules
- Every `__init__.py` re-exports its module's public API
- Views, serializers, models — all imported from their directories, never from a single file
- Use absolute imports in Python: `from apps.{app_name}.models import ModelName`
- Use path aliases in TypeScript: `@/features/{feature}/...`

---

## Database Optimization Standards

### Mandatory for Every Model
- **Consult the `database-optimizer` agent** (`/.claude/agents/database-optimizer.md`) when designing models, writing queries, or adding indexes
- Add `db_index=True` on all foreign keys and frequently filtered fields
- Add `Meta.indexes` for compound query patterns
- Use `select_related()` and `prefetch_related()` — **N+1 queries are never acceptable**
- Use `only()` and `defer()` for large text/JSON fields not needed in list views
- Paginate everything — cursor-based pagination for API list endpoints

### Query Rules
- No raw SQL unless the ORM genuinely cannot express the query
- No queries inside loops — use bulk operations (`bulk_create`, `bulk_update`)
- Annotate/aggregate at the database level, not in Python
- Use `Exists()` subqueries instead of `.count() > 0`
- Use `F()` expressions for atomic updates
- Add `EXPLAIN ANALYZE` comments for complex queries during review

### Migration Rules
- Every migration must be reviewed for lock safety (no `ALTER TABLE` on large tables without `CONCURRENTLY`)
- Add indexes concurrently: `AddIndex` with `opclasses` where appropriate
- Never add a non-nullable field without a default in a migration

---

## Security Standards

### Every Endpoint Must Have
1. **Authentication** — `IsAuthenticated` or explicitly `AllowAny` (document why)
2. **Authorization** — object-level permissions (users can only access their own data)
3. **Input validation** — DRF serializer validation, no raw `request.data` access
4. **Rate limiting** — `@ratelimit` decorator with appropriate limits
5. **Audit logging** — security-sensitive actions logged (login, password change, payment, role change)

### Injection Prevention
- Use ORM exclusively — no string concatenation in queries
- Parameterize all database queries if raw SQL is unavoidable
- Sanitize file names on upload (`django.utils.text.get_valid_filename`)
- Validate file types by content (magic bytes), not just extension
- Set `Content-Security-Policy` headers

### Secrets
- All secrets from env vars (`os.environ` / `django-environ`)
- No hardcoded keys, tokens, passwords anywhere in code
- `.env` in `.gitignore` — committed `.env.example` has placeholder values only
- Webhook signature verification on every webhook

---

## UI Standards

### Design Reference UI Kits

> **MANDATORY:** Before designing ANY new page or component, consult the reference UI kits for the equivalent design pattern. Match their spacing, border radius, shadows, typography, and color usage.

| Kit | Path | Use For |
|-----|------|---------|
| **[Web UI Kit]** | `/path/to/web-ui-kit/` | Web/admin: dashboard, tables, forms, cards, sidebar |
| **[Mobile UI Kit]** | `/path/to/mobile-ui-kit/` | Mobile: screens, cards, lists, navigation |
| **Branding** | `https://your-brand-site.com` | Brand colors, visual identity |

### Mobile-First Design Philosophy

> **This app is mobile-first.** The web experience must look and behave like a mobile app first, then progressively enhance for larger screens.

### Web (Next.js + shadcn/ui)
- **Component library:** shadcn/ui — all UI primitives from shadcn
- **Component-based architecture:** Every UI element is a reusable component. No page-level inline markup blobs.

#### CSS Rules — No Inline Styles

**All CSS must live in separate CSS files. Never write inline `style={{}}` or long Tailwind class strings directly in JSX.**

| Approach | When to Use |
|----------|------------|
| **CSS Modules** (`*.module.css`) | Custom component styles, layouts, page-specific styles |
| **`globals.css`** | shadcn CSS variables, base resets, app-wide utility classes |
| **shadcn `cn()` helper** | Only for shadcn's own components (button variants, etc.) — keep it minimal |
| **Standard CSS** | Inside CSS Module files — write plain CSS properties, NOT `@apply` |

#### CRITICAL: Tailwind CSS v4 Compatibility

> **If using Tailwind CSS v4: The `@apply` directive does NOT work in CSS Modules without `@reference`, and even with `@reference` it fails for custom theme utilities. DO NOT USE `@apply` in CSS Modules.**

**Rules:**
1. **NEVER use `@apply` in `.module.css` files** — it breaks the build with Tailwind v4
2. **Write standard CSS properties** instead of Tailwind utilities in CSS Modules
3. **Use `var(--variable)` for shadcn theme colors** (e.g., `color: var(--muted-foreground)`). **NEVER use `hsl(var(--variable))`** — Tailwind v4 stores OKLCH/LAB values, not HSL triplets, so `hsl()` wrapper produces invalid CSS. For alpha/opacity, use `color-mix(in srgb, var(--primary) 10%, transparent)` instead of `hsl(var(--primary) / 0.1)`.
4. **Use `@media` queries for responsive design** instead of Tailwind responsive prefixes
5. **Use `:hover` pseudo-selectors** instead of Tailwind hover utilities

**Correct pattern:**
```css
/* components/layout/Header.module.css */
.header {
  position: sticky;
  top: 0;
  z-index: 50;
  width: 100%;
  border-bottom: 1px solid var(--border);
  background-color: color-mix(in srgb, var(--background) 95%, transparent);
  backdrop-filter: blur(8px);
}

.header__inner {
  display: flex;
  height: 3.5rem;
  align-items: center;
  padding-left: 1rem;
  padding-right: 1rem;
}

@media (min-width: 768px) {
  .header__inner {
    padding-left: 1.5rem;
    padding-right: 1.5rem;
  }
}
```
```tsx
// components/layout/Header.tsx
import styles from "./Header.module.css";

export function Header() {
  return (
    <header className={styles.header}>
      <div className={styles.header__inner}>
        <Link href="/" className={styles.header__logo}>...</Link>
        <div className={styles.header__search}>...</div>
        <div className={styles.header__actions}>...</div>
      </div>
    </header>
  );
}
```

**Forbidden:**
```css
/* NEVER — @apply in CSS Modules (breaks Tailwind v4 build) */
.header {
  @apply sticky top-0 z-50 w-full border-b;
  @apply bg-background/95 backdrop-blur;
}
```
```tsx
// NEVER — long inline Tailwind strings
<div className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">

// NEVER — inline style objects
<div style={{ padding: "16px", display: "flex" }}>
```

**Exception:** shadcn/ui auto-generated components in `components/ui/` may use `cn()` with Tailwind — do not edit these files. They are managed by the shadcn CLI.

#### shadcn/ui v2 (Base UI) Compatibility

> **If using shadcn/ui v2: it uses `@base-ui/react` instead of Radix UI for some components.** The APIs differ between the two.

**Key differences:**
1. **`asChild` does NOT exist on Base UI components** — use `render` prop instead
   - Base UI (Sheet, Dialog): `<SheetTrigger render={<Button />}>...</SheetTrigger>`
   - Radix (DropdownMenu, Select): `<DropdownMenuTrigger asChild><Button>...</Button></DropdownMenuTrigger>`
2. **Check which primitive each component uses** before writing code:
   - Base UI (`@base-ui/react`): Sheet, Dialog — use `render` prop
   - Radix (`@radix-ui/react-*`): Select, DropdownMenu — use `asChild` prop
3. **Base UI Select `onValueChange` passes `string | null`** — always handle null: `(v) => setState(String(v ?? ""))`
4. **Button `size` variants** — only use values defined in the button component (check `components/ui/button.tsx`). Common: `"default"`, `"sm"`, `"lg"`, `"icon"`.
5. **Badge `variant` values** — only use variants defined in the badge component. Common: `"default"`, `"secondary"`, `"destructive"`, `"outline"`.
6. **Always verify the build compiles** after adding new pages or components: `npm run build`

#### Next.js App Router Rules

1. **`useSearchParams()` must be wrapped in `<Suspense>`** — Next.js requires this for static generation. Split the page into a wrapper with Suspense and an inner content component.
2. **Always pass type parameters to generic API calls** — `api.get<MyType>(url)` not `api.get(url)` to avoid `unknown` type errors.
3. **Verify all shadcn/ui components are installed** before importing — run `npx shadcn@latest add <component>` if missing.
4. **Install all npm dependencies** before building — `react-hook-form`, `@hookform/resolvers`, `zod`, `@tanstack/react-query`, etc.

#### File Naming for CSS Modules

Every component that needs custom styles gets a companion CSS Module:
```
components/layout/
├── Header.tsx
├── Header.module.css
├── Sidebar.tsx
├── Sidebar.module.css
├── MobileNav.tsx
├── MobileNav.module.css
├── Footer.tsx
└── Footer.module.css
```

- **Mobile-first CSS:** Always write mobile styles first, then add responsive breakpoints
  - Default styles = mobile (320px+)
  - `@media (min-width: 640px)` = tablet portrait
  - `@media (min-width: 768px)` = tablet landscape
  - `@media (min-width: 1024px)` = desktop
  - `@media (min-width: 1280px)` = wide desktop
- **Theme:** Full light mode AND dark mode compliance
  - Use CSS variables from shadcn theme system
  - Every component must render correctly in both themes
  - `next-themes` ThemeProvider wrapping the app with `system` / `light` / `dark` toggle
  - Test both themes before marking any UI task complete
- **Touch-friendly:** All interactive elements must have minimum 44px touch targets
- **Bottom navigation:** Mobile web uses bottom tab bar (like a native app), not top nav
- **Accessibility:** WCAG 2.1 AA — proper aria labels, keyboard navigation, focus management

### Mobile (React Native)

> **All engineering standards apply equally to mobile.** TDD, SDD, no god files, 300-line limit, directory-based modules, dynamic testing, component-based architecture, CSS-in-files, contract-first, skill consultation — everything in this document applies to React Native code.

- **Theme:** Light and dark mode using `useColorScheme()` + custom theme provider
- **Responsive:** Handle different screen sizes with Dimensions API and flex layouts
- **Platform-specific:** Use `Platform.select()` only when genuinely needed (iOS vs Android differences)

#### Component-Based Architecture (Mobile)

Every screen is composed of reusable components. No monolithic screen files with all markup inline.

```
src/
├── components/
│   ├── layout/
│   │   ├── TabBar.tsx
│   │   ├── TabBar.styles.ts         # StyleSheet companion
│   │   ├── ScreenHeader.tsx
│   │   └── ScreenHeader.styles.ts
│   └── shared/
│       ├── LoadingSpinner.tsx
│       └── LoadingSpinner.styles.ts
├── features/
│   ├── {feature}/
│   │   ├── components/
│   │   │   ├── FeatureCard.tsx
│   │   │   └── FeatureCard.styles.ts
│   │   ├── screens/
│   │   │   ├── FeatureScreen.tsx
│   │   │   └── FeatureScreen.styles.ts
│   │   ├── hooks/
│   │   ├── services/
│   │   └── types/
```

#### No Inline Styles (Mobile)

**All styles must live in companion `*.styles.ts` files using `StyleSheet.create()`. Never write inline `style={{}}` objects in JSX.**

**Correct pattern:**
```typescript
// components/layout/ScreenHeader.styles.ts
import { StyleSheet } from "react-native";

export const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: "var(--border)", // from theme
  },
  title: {
    fontSize: 18,
    fontWeight: "600",
  },
  actions: {
    flexDirection: "row",
    gap: 8,
    marginLeft: "auto",
  },
});
```
```tsx
// components/layout/ScreenHeader.tsx
import { View, Text } from "react-native";
import { styles } from "./ScreenHeader.styles";

export function ScreenHeader({ title, children }) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
      <View style={styles.actions}>{children}</View>
    </View>
  );
}
```

**Forbidden:**
```tsx
// NEVER — inline style objects
<View style={{ flexDirection: "row", padding: 16, alignItems: "center" }}>
  <Text style={{ fontSize: 18, fontWeight: "600" }}>{title}</Text>
</View>

// NEVER — styles defined at bottom of component file
// (put them in a separate .styles.ts file)
const styles = StyleSheet.create({...}); // at bottom of component file
```

#### Dynamic Testing (Mobile)

- **Detox or Maestro** for e2e: real device/emulator interactions (tap, swipe, type, assert)
- Tests follow user journey pattern — simulate what a real user does on each screen
- Every screen and interaction must have corresponding e2e tests
- Unit tests for hooks/services with real API mocks

```typescript
// e2e/feature.test.ts (Detox example)
describe("Feature Journey", () => {
  it("user browses and interacts with feature", async () => {
    await element(by.text("Feature")).tap();
    await expect(element(by.id("feature-list"))).toBeVisible();
    await element(by.id("feature-card-0")).tap();
    await expect(element(by.id("feature-detail"))).toBeVisible();
    await element(by.id("action-button")).tap();
    await expect(element(by.id("action-button"))).toHaveLabel("Done");
  });
});
```

#### Contracts Apply to Mobile

- Mobile TypeScript types must match `docs/contracts/*.contract.ts` exactly
- Same `snake_case` field names as backend and web — no conversion
- Same enum values (`UPPER_SNAKE_CASE`) — no conversion
- Same API client pattern as web (fetch wrapper with auth headers)
- Same Zustand store patterns as web

---

## Skill Consultation Mandate

### Before implementing ANY feature, endpoint, or functionality:

1. **Read relevant skills** from `.claude/skills/` that relate to the work:
   - Building a new API? → Consult `senior-security`, `database-optimizer`
   - Working on frontend? → Consult `frontend-design`, `web-perf`
   - Writing tests? → Consult `qa-testing`, `test-driven-development`
   - Handling payments? → Consult `stripe-integration` (for patterns), `senior-security`
   - Building AI features? → Consult `context-engineering`, `context-fundamentals`
   - Security-sensitive code? → Consult `senior-security`, `vibesec-security`, `security-code-review`
   - Database work? → Consult `database-optimizer` agent

2. **Read relevant commands** from `.claude/commands/`:
   - Starting a new feature? → Read `create-prd.md`
   - Analyzing architecture? → Read `ultra-think.md`
   - Setting up a new module? → Read `init-project.md`

3. **Document which skills were consulted** in the session handoff

### Available Skills (`.claude/skills/`):
- `01-Software-Web-Development/` — 15 skills (frontend, MCP, Cloudflare, Stripe, etc.)
- `02-Context-Engineering-AI/` — 18 skills (context optimization, prompt engineering, etc.)
- `03-Security/` — security code review, vibesec
- `04-QA-Testing/` — QA testing, test planning
- `05-Document-Processing/` — PDF, DOCX processing
- `06-Meta-Process/` — meta-level process skills
- `senior-security/` — threat modeling, security auditing, pen testing
- `product-manager-toolkit/` — PRD templates, RICE prioritization
- `frontend-design/`, `web-perf/`, `webapp-testing/` — frontend skills

### Available Agents (`.claude/agents/`):
- `database-optimizer` — query optimization, indexing, performance tuning

---

## Code Quality Checklist

Before marking ANY task complete, verify:

- [ ] Tests written FIRST (TDD) and all passing
- [ ] All tests are **dynamic** — real HTTP requests (backend), real browser interactions (frontend)
- [ ] Tests follow **user journey** pattern — not isolated import/existence checks
- [ ] No file exceeds 300 lines — if it does, split into directory with multiple files
- [ ] Code is in directory-based modules with proper `__init__.py` imports
- [ ] No N+1 queries (use `select_related`/`prefetch_related`)
- [ ] All endpoints have auth, authorization, validation, rate limiting
- [ ] No hardcoded secrets
- [ ] Web CSS Modules use standard CSS only — NO `@apply` (Tailwind v4 breaks)
- [ ] Web: `npx tsc -b` passes with zero errors (primary type check for frontend)
- [ ] Web: `npm run build` passes with zero errors (both frontend and admin)
- [ ] Web: `useSearchParams()` wrapped in `<Suspense>` boundary
- [ ] Web: shadcn component APIs match actual installed version (check `render` vs `asChild`, variant values)
- [ ] Web UI works in light AND dark mode
- [ ] Web UI is responsive (mobile, tablet, desktop)
- [ ] Mobile: styles in `*.styles.ts` files (no inline `style={{}}`)
- [ ] Mobile: component-based (no monolithic screen files)
- [ ] Mobile: e2e tests with Detox/Maestro following user journeys
- [ ] Relevant skills were consulted before implementation
- [ ] Security review completed on sensitive code (DAST scan for auth/payment endpoints)
- [ ] Database queries are optimized (indexes, no loops, bulk ops)
