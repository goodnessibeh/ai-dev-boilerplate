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

### Reference Guides (consult before implementation)

> These reference documents live in `.ai/skills/` and `.ai/agents/`. Read them before writing code in the relevant area.
> **Note:** If using Claude Code, these are also available at `.claude/skills/` and `.claude/agents/`.

| Resource | Path | When to Consult |
|----------|------|----------------|
| Senior Security | `.ai/skills/senior-security/` | Auth, payments, file uploads, any user-facing endpoint |
| Database Optimizer | `.ai/agents/database-optimizer.md` | Model design, queries, indexes, migrations |
| Frontend Design | `.ai/skills/frontend-design/` | UI components, layouts, interactions |
| Web Performance | `.ai/skills/web-perf/` | Page load, bundle size, rendering performance |
| QA Testing | `.ai/skills/qa-testing/` | Test strategy, test writing, coverage |
| TDD | `.ai/skills/test-driven-development/` | TDD workflow, test-first approach |
| Security Code Review | `.ai/skills/security-code-review/` | Code review for vulnerabilities |
| Context Engineering | `.ai/skills/context-engineering/` | AI agent prompt design, context optimization |
| Product Manager Toolkit | `.ai/skills/product-manager-toolkit/` | PRD creation, feature prioritization |
| All Software Skills | `.ai/skills/01-Software-Web-Development/` | Framework-specific guidance |
| All AI Skills | `.ai/skills/02-Context-Engineering-AI/` | AI/ML implementation guidance |
| All Security Skills | `.ai/skills/03-Security/` | Security patterns and reviews |
| All QA Skills | `.ai/skills/04-QA-Testing/` | Testing strategies |
| All Commands | `.ai/commands/` | `ultra-think`, `create-prd`, `init-project`, `setup-development-environment` |

### Agent Workflow

```
1.  Read this engineering standards file — understand standards
2.  Read handoff/SESSION_MEMORY.md — understand project state
3.  Read latest handoff/SESSION_NNN_*.md — understand what comes next
4.  Read docs/TECHNICAL_PRD.md — understand the feature being built
5.  Read docs/BUILD_PLAN.md — understand the current sprint tasks
6.  Read docs/AGENT_COORDINATION.md — understand contracts, naming, enums
7.  Read docs/contracts/_enums.contract.ts — enum values for the feature
8.  Read docs/contracts/{module}.contract.ts — exact API contract for the feature
9.  Consult relevant .ai/skills/ guides — before writing any code
10. Implement with TDD + SDD (contract-first, test-first, security-first)
11. Validate against contract (integration checklist from AGENT_COORDINATION.md)
12. Write handoff at session end
```

### Plan Mode Requirements

**MANDATORY: Every new feature MUST go through plan mode.** When the user requests a new feature, the agent MUST automatically enter plan mode — even if the user does not explicitly ask for it. Do NOT start writing code until planning is complete.

**Plan mode flow:**
1. **Automatically enter plan mode** when a new feature is requested — no exceptions.
2. **Ask open-ended clarifying questions** to fully understand the feature before writing any code. Examples:
   - "What user roles interact with this feature?"
   - "How should this behave on mobile vs desktop?"
   - "Are there edge cases around [X] we should handle?"
   - "What's the expected scale / data volume?"
   - "Does this need to integrate with any existing modules?"
   - "What does success look like for this feature?"
   - "Are there any third-party services or APIs involved?"
3. **Do not assume requirements** — if something is ambiguous, ask. It's better to ask 5 questions upfront than to rebuild after implementation.
4. **Present a phased sprint plan** after questions are answered (see Phased Sprint Approach below).
5. **Get explicit sign-off** on the plan before starting implementation.

> **Bug fixes, small tweaks, and config changes** do not require plan mode — only new features and significant enhancements.

### Phased Sprint Approach

Every feature implementation MUST use a phased sprint approach. No feature ships as a single monolithic block.

**Format:** `Sprint N — Phase M` (e.g., Sprint 1 — Phase 1, Sprint 1 — Phase 2, Sprint 2 — Phase 1)

**Structure:**
- **Phase 1:** Core models, migrations, basic API endpoints, unit tests
- **Phase 2:** Business logic, services, validation, integration tests
- **Phase 3:** Frontend UI, user flows, E2E tests
- **Phase 4:** Polish, edge cases, performance optimization, security hardening

Each phase MUST have a **todo list** with concrete, checkable tasks. Example:

```
### Sprint 1 — Phase 1: Core Models & API
- [ ] Create `Notification` model with fields: user, type, message, read, created_at
- [ ] Add migration with indexes on user + created_at
- [ ] POST /api/v1/notifications/ endpoint
- [ ] GET /api/v1/notifications/ with pagination
- [ ] PATCH /api/v1/notifications/{id}/read/
- [ ] Write pytest tests for all endpoints
- [ ] Verify all tests pass
```

Each phase must be:
- Self-contained and deployable on its own
- Documented in `docs/BUILD_PLAN.md` with its todo list
- All todos checked off before moving to the next phase
- Reviewed against the plan before proceeding

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
- **No AI references:** Never include any AI tool name (Claude, Codex, Kimi, DeepSeek, Copilot, etc.), "AI-generated", "Co-Authored-By", or similar in commit messages
- **Commit format:** Clear, descriptive messages explaining what was done
- **No force push** to main without explicit approval
- **Always `git add .` from project root** — never add individual files, always stage everything from root to catch all changes across backend/frontend/admin/mobile
- **Use `IF NOT EXISTS`** for database column additions in migrations to avoid errors on re-run
- **Ask about handoff on every commit:** After every `git commit`, ask the user if a session handoff should be written. Never skip this prompt.
- **Session handoff on every push:** Every `git push` MUST be preceded by writing a session handoff (`handoff/SESSION_NNN_*.md`) and updating `handoff/SESSION_MEMORY.md`. No push without a handoff — this ensures continuity across sessions and agents.

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
3. **Consult the `senior-security` reference guide** (`.ai/skills/senior-security/`) before implementing auth, payments, file handling, or any user-facing endpoint
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
- **Consult the `database-optimizer` reference guide** (`.ai/agents/database-optimizer.md`) when designing models, writing queries, or adding indexes
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

### Core Principles

> **Every UI is built from reusable components. Every page is mobile-responsive. Every element follows the brand.**

1. **Component-based architecture** — never write raw HTML/JSX markup directly in pages. Every UI element is a named, reusable component.
2. **Mobile-responsive by default** — every page and component must work flawlessly from 320px to 2560px. Mobile is designed first, then progressively enhanced.
3. **Consistent branding** — colors, typography, spacing, border radius, shadows, and iconography come from a single design system. No ad-hoc values.
4. **Reuse over recreation** — before building a new component, check if one already exists in `components/shared/` or `components/ui/`. Extend existing components before creating new ones.

### Zero Raw HTML Rule

**Never write raw HTML tags or unstructured JSX blobs directly in page files.** Every visible element must be a named component.

```tsx
// NEVER — raw HTML dump in a page
export default function DashboardPage() {
  return (
    <div>
      <div style={{ display: "flex", gap: 16 }}>
        <div className="card">
          <h3>Users</h3>
          <p>1,234</p>
        </div>
        <div className="card">
          <h3>Revenue</h3>
          <p>$12,345</p>
        </div>
      </div>
    </div>
  );
}

// CORRECT — component-based composition
import { PageShell } from "@/components/layout/PageShell";
import { StatCard } from "@/components/shared/StatCard";
import { CardGrid } from "@/components/shared/CardGrid";

export default function DashboardPage() {
  return (
    <PageShell title="Dashboard">
      <CardGrid>
        <StatCard label="Users" value="1,234" icon="users" />
        <StatCard label="Revenue" value="$12,345" icon="dollar" trend="+12%" />
      </CardGrid>
    </PageShell>
  );
}
```

**Rules:**
1. **Page files (`page.tsx`)** should ONLY compose components — no raw `<div>`, `<section>`, `<h1>`, `<p>`, `<span>`, `<img>` tags directly. Wrap them in named components.
2. **If you use any HTML element more than once**, it MUST become a shared component (`components/shared/`).
3. **If you use a pattern across features** (cards, lists, filters, empty states, loading states), it MUST be in `components/shared/`.
4. **Maximum 3 lines of raw JSX in a page** — anything more must be extracted into a component.

### Reusable Component Library

Every project must build and maintain a shared component library. These components are the building blocks for all pages.

```
components/
├── ui/                          # Primitive UI components (shadcn/ui or custom)
│   ├── button.tsx               # Button with size/variant props
│   ├── input.tsx                # Form input with label, error, helper text
│   ├── badge.tsx                # Status badges
│   ├── card.tsx                 # Card container
│   ├── dialog.tsx               # Modal dialog
│   ├── select.tsx               # Dropdown select
│   └── ...                      # Other primitives
├── shared/                      # Reusable composed components
│   ├── PageShell.tsx            # Standard page wrapper (title, breadcrumbs, actions)
│   ├── DataTable.tsx            # Sortable, filterable table with pagination
│   ├── StatCard.tsx             # Metric card (label, value, icon, trend)
│   ├── CardGrid.tsx             # Responsive grid of cards
│   ├── EmptyState.tsx           # Empty state with icon, message, action
│   ├── LoadingSpinner.tsx       # Loading indicator
│   ├── ErrorBoundary.tsx        # Error boundary with fallback UI
│   ├── SearchInput.tsx          # Search with debounce
│   ├── FilterBar.tsx            # Horizontal filter pills/dropdowns
│   ├── StatusBadge.tsx          # Color-coded status indicator
│   ├── Avatar.tsx               # User avatar with fallback initials
│   ├── ConfirmDialog.tsx        # Confirmation modal (delete, destructive actions)
│   ├── FormField.tsx            # Form field wrapper (label + input + error)
│   └── Pagination.tsx           # Page/cursor navigation
├── layout/                      # Page structure components
│   ├── Header.tsx               # App header (logo, search, user menu)
│   ├── Sidebar.tsx              # Navigation sidebar (desktop)
│   ├── MobileNav.tsx            # Bottom tab bar (mobile)
│   ├── Footer.tsx               # App footer
│   └── ThemeToggle.tsx          # Light/dark mode toggle
└── brand/                       # Brand-specific components
    ├── Logo.tsx                  # Logo (SVG, responsive sizes)
    ├── BrandColors.ts           # Exported brand color constants
    └── Typography.tsx           # Heading, Body, Caption components with brand fonts
```

**Before creating any new component, ask:**
1. Does a similar component already exist in `components/shared/` or `components/ui/`?
2. Can I extend an existing component with a new prop/variant instead?
3. Will this be used more than once? If yes → `components/shared/`. If once → feature-level component.

### Consistent Branding & Design Tokens

**All visual properties must come from a centralized design system — never use hardcoded values.**

```css
/* globals.css — Define ALL design tokens here */
:root {
  /* Brand Colors */
  --brand-primary: #0067FF;        /* Main brand color */
  --brand-primary-hover: #0052CC;
  --brand-secondary: #6C757D;
  --brand-accent: #FF6B2B;

  /* Semantic Colors (from shadcn or custom) */
  --background: ...;
  --foreground: ...;
  --muted: ...;
  --muted-foreground: ...;
  --border: ...;
  --ring: ...;

  /* Spacing Scale */
  --space-xs: 0.25rem;    /* 4px */
  --space-sm: 0.5rem;     /* 8px */
  --space-md: 1rem;       /* 16px */
  --space-lg: 1.5rem;     /* 24px */
  --space-xl: 2rem;       /* 32px */
  --space-2xl: 3rem;      /* 48px */

  /* Border Radius */
  --radius-sm: 0.375rem;  /* 6px */
  --radius-md: 0.5rem;    /* 8px */
  --radius-lg: 0.75rem;   /* 12px */
  --radius-full: 9999px;

  /* Typography */
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", monospace;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
}
```

**Rules:**
1. **Never hardcode colors** — use `var(--brand-primary)`, `var(--muted-foreground)`, etc.
2. **Never hardcode spacing** — use the spacing scale (`var(--space-md)`) or consistent rem values.
3. **Never hardcode border-radius** — use `var(--radius-md)` etc.
4. **Never hardcode font families** — use `var(--font-sans)`.
5. **Never hardcode shadows** — use `var(--shadow-sm)`, `var(--shadow-md)`, `var(--shadow-lg)`.
6. **All design token changes happen in ONE place** (`globals.css` or theme config) and propagate everywhere.
7. **Dark mode** must use the same token names — the values change, the names don't.

### Design Reference UI Kits

> Before designing ANY new page or component, consult the reference UI kits for the equivalent design pattern. Match their spacing, border radius, shadows, typography, and color usage.

| Kit | Path | Use For |
|-----|------|---------|
| **[Web UI Kit]** | `/path/to/web-ui-kit/` | Web/admin: dashboard, tables, forms, cards, sidebar |
| **[Mobile UI Kit]** | `/path/to/mobile-ui-kit/` | Mobile: screens, cards, lists, navigation |
| **Branding** | `https://your-brand-site.com` | Brand colors, visual identity |

### Mobile-Responsive Design (Mandatory)

> **Every page, every component, every layout must be fully responsive from 320px to 2560px.** There are no "desktop-only" components.

#### Responsive Breakpoints

Design and code mobile-first — default styles are for the smallest screen, then enhance upward:

| Breakpoint | Target | CSS |
|-----------|--------|-----|
| Default | Mobile (320px+) | Base styles — no media query needed |
| `640px` | Tablet portrait | `@media (min-width: 640px)` |
| `768px` | Tablet landscape | `@media (min-width: 768px)` |
| `1024px` | Desktop | `@media (min-width: 1024px)` |
| `1280px` | Wide desktop | `@media (min-width: 1280px)` |

#### Responsive Component Patterns

```css
/* components/shared/CardGrid.module.css */
.grid {
  display: grid;
  gap: var(--space-md);
  grid-template-columns: 1fr;          /* Mobile: single column */
}

@media (min-width: 640px) {
  .grid {
    grid-template-columns: repeat(2, 1fr);  /* Tablet: 2 columns */
  }
}

@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);  /* Desktop: 3 columns */
    gap: var(--space-lg);
  }
}

@media (min-width: 1280px) {
  .grid {
    grid-template-columns: repeat(4, 1fr);  /* Wide: 4 columns */
  }
}
```

**Responsive rules:**
1. **Every grid/layout component** must define behavior at all breakpoints.
2. **Navigation** — mobile uses bottom tab bar, desktop uses sidebar. Both must be components (`MobileNav.tsx`, `Sidebar.tsx`), toggled by viewport.
3. **Tables** — must collapse to card layout on mobile. Use `DataTable` component with built-in responsive mode.
4. **Forms** — single column on mobile, multi-column on desktop. Fields stack vertically at small widths.
5. **Modals/dialogs** — full-screen sheet on mobile, centered dialog on desktop.
6. **Images** — responsive with `sizes` attribute, lazy-loaded, aspect-ratio preserved.
7. **Touch targets** — minimum 44px on all interactive elements (buttons, links, form controls).
8. **Test at 320px, 768px, 1024px, 1440px** before marking any UI task complete.

### Web (Next.js + shadcn/ui)

- **Component library:** shadcn/ui — all UI primitives from shadcn
- **Every page is a composition of components** — no raw markup in page files

#### CSS Rules — No Inline Styles

**All CSS must live in separate CSS files. Never write inline `style={{}}` or long Tailwind class strings directly in JSX.**

| Approach | When to Use |
|----------|------------|
| **CSS Modules** (`*.module.css`) | Custom component styles, layouts, page-specific styles |
| **`globals.css`** | Design tokens, shadcn CSS variables, base resets |
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
  padding-left: var(--space-md);
  padding-right: var(--space-md);
}

@media (min-width: 768px) {
  .header__inner {
    padding-left: var(--space-lg);
    padding-right: var(--space-lg);
  }
}
```
```tsx
// components/layout/Header.tsx
import styles from "./Header.module.css";
import { Logo } from "@/components/brand/Logo";
import { SearchInput } from "@/components/shared/SearchInput";
import { ThemeToggle } from "@/components/layout/ThemeToggle";

export function Header() {
  return (
    <header className={styles.header}>
      <div className={styles.header__inner}>
        <Logo size="sm" />
        <SearchInput className={styles.header__search} />
        <ThemeToggle />
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
}
```
```tsx
// NEVER — long inline Tailwind strings
<div className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur">

// NEVER — inline style objects
<div style={{ padding: "16px", display: "flex" }}>

// NEVER — raw HTML in page files
<div><h1>Dashboard</h1><p>Welcome back</p></div>
```

**Exception:** shadcn/ui auto-generated components in `components/ui/` may use `cn()` with Tailwind — do not edit these files.

#### shadcn/ui v2 (Base UI) Compatibility

> **If using shadcn/ui v2: it uses `@base-ui/react` instead of Radix UI for some components.**

**Key differences:**
1. **`asChild` does NOT exist on Base UI components** — use `render` prop instead
   - Base UI (Sheet, Dialog): `<SheetTrigger render={<Button />}>...</SheetTrigger>`
   - Radix (DropdownMenu, Select): `<DropdownMenuTrigger asChild><Button>...</Button></DropdownMenuTrigger>`
2. **Check which primitive each component uses** before writing code
3. **Base UI Select `onValueChange` passes `string | null`** — always handle null
4. **Only use variant/size values that actually exist** in the component definition — check `components/ui/` first
5. **Always verify the build compiles** after adding new pages or components: `npm run build`

#### Next.js App Router Rules

1. **`useSearchParams()` must be wrapped in `<Suspense>`**
2. **Always pass type parameters to generic API calls** — `api.get<MyType>(url)` not `api.get(url)`
3. **Verify all shadcn/ui components are installed** before importing
4. **Install all npm dependencies** before building

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
```

#### Theme & Accessibility

- **Theme:** Full light mode AND dark mode compliance
  - Use CSS variables from the design token system
  - Every component must render correctly in both themes
  - `next-themes` ThemeProvider wrapping the app with `system` / `light` / `dark` toggle
  - Test both themes before marking any UI task complete
- **Accessibility:** WCAG 2.1 AA — proper aria labels, keyboard navigation, focus management, color contrast ratios

### Mobile (React Native)

> **All engineering standards apply equally to mobile.** TDD, SDD, no god files, 300-line limit, directory-based modules, dynamic testing, component-based architecture, contract-first — everything applies.

- **Component-first:** Same zero-raw-markup rule as web. Every screen is composed of named, reusable components.
- **Theme:** Light and dark mode using `useColorScheme()` + custom theme provider
- **Responsive:** Handle different screen sizes with Dimensions API and flex layouts
- **Consistent branding:** Same design tokens (colors, spacing, typography) as web — adapted for React Native

#### Component-Based Architecture (Mobile)

Every screen is composed of reusable components. No monolithic screen files.

```
src/
├── components/
│   ├── layout/
│   │   ├── TabBar.tsx
│   │   ├── TabBar.styles.ts
│   │   ├── ScreenHeader.tsx
│   │   └── ScreenHeader.styles.ts
│   ├── shared/                    # Reusable across all features
│   │   ├── StatCard.tsx
│   │   ├── StatCard.styles.ts
│   │   ├── EmptyState.tsx
│   │   ├── EmptyState.styles.ts
│   │   ├── LoadingSpinner.tsx
│   │   ├── LoadingSpinner.styles.ts
│   │   ├── Avatar.tsx
│   │   └── Avatar.styles.ts
│   └── brand/
│       ├── Logo.tsx
│       └── theme.ts               # Brand colors, spacing, typography constants
├── features/
│   ├── {feature}/
│   │   ├── components/            # Feature-specific components
│   │   │   ├── FeatureCard.tsx
│   │   │   └── FeatureCard.styles.ts
│   │   ├── screens/               # Screens compose components — no raw markup
│   │   │   ├── FeatureScreen.tsx
│   │   │   └── FeatureScreen.styles.ts
│   │   ├── hooks/
│   │   ├── services/
│   │   └── types/
```

#### No Inline Styles (Mobile)

**All styles must live in companion `*.styles.ts` files using `StyleSheet.create()`. Never write inline `style={{}}` objects.**

```typescript
// components/shared/StatCard.styles.ts
import { StyleSheet } from "react-native";
import { theme } from "@/components/brand/theme";

export const styles = StyleSheet.create({
  container: {
    backgroundColor: theme.colors.card,
    borderRadius: theme.radius.md,
    padding: theme.spacing.md,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  label: {
    fontSize: 14,
    color: theme.colors.mutedForeground,
    fontFamily: theme.fonts.sans,
  },
  value: {
    fontSize: 24,
    fontWeight: "700",
    color: theme.colors.foreground,
    fontFamily: theme.fonts.sans,
    marginTop: theme.spacing.xs,
  },
});
```
```tsx
// components/shared/StatCard.tsx
import { View, Text } from "react-native";
import { styles } from "./StatCard.styles";

interface StatCardProps {
  label: string;
  value: string;
  icon?: string;
}

export function StatCard({ label, value, icon }: StatCardProps) {
  return (
    <View style={styles.container}>
      <Text style={styles.label}>{label}</Text>
      <Text style={styles.value}>{value}</Text>
    </View>
  );
}
```

**Forbidden:**
```tsx
// NEVER — inline style objects
<View style={{ flexDirection: "row", padding: 16 }}>

// NEVER — styles at bottom of component file
const styles = StyleSheet.create({...}); // belongs in *.styles.ts

// NEVER — raw View/Text blobs in screen files without component abstraction
```

#### Dynamic Testing (Mobile)

- **Detox or Maestro** for e2e: real device/emulator interactions (tap, swipe, type, assert)
- Tests follow user journey pattern — simulate what a real user does on each screen
- Every screen and interaction must have corresponding e2e tests

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

1. **Read relevant reference guides** from `.ai/skills/` that relate to the work:
   - Building a new API? → Consult `senior-security`, `database-optimizer`
   - Working on frontend? → Consult `frontend-design`, `web-perf`
   - Writing tests? → Consult `qa-testing`, `test-driven-development`
   - Handling payments? → Consult `stripe-integration` (for patterns), `senior-security`
   - Building AI features? → Consult `context-engineering`, `context-fundamentals`
   - Security-sensitive code? → Consult `senior-security`, `vibesec-security`, `security-code-review`
   - Database work? → Consult `database-optimizer` agent guide

2. **Read relevant command guides** from `.ai/commands/`:
   - Starting a new feature? → Read `create-prd.md`
   - Analyzing architecture? → Read `ultra-think.md`
   - Setting up a new module? → Read `init-project.md`

3. **Document which skills were consulted** in the session handoff

### Available Reference Guides (`.ai/skills/`):
- `01-Software-Web-Development/` — 15 guides (frontend, MCP, Cloudflare, Stripe, etc.)
- `02-Context-Engineering-AI/` — 18 guides (context optimization, prompt engineering, etc.)
- `03-Security/` — security code review, vibesec
- `04-QA-Testing/` — QA testing, test planning
- `05-Document-Processing/` — PDF, DOCX processing
- `06-Meta-Process/` — meta-level process guides
- `senior-security/` — threat modeling, security auditing, pen testing
- `product-manager-toolkit/` — PRD templates, RICE prioritization
- `frontend-design/`, `web-perf/`, `webapp-testing/` — frontend guides

### Available Agent Guides (`.ai/agents/`):
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
- [ ] **Zero raw HTML** in page files — all UI is composed from named components
- [ ] Reusable components exist in `components/shared/` — no duplicated UI patterns
- [ ] All colors, spacing, radius, shadows use design tokens (CSS variables) — no hardcoded values
- [ ] Web CSS Modules use standard CSS only — NO `@apply` (Tailwind v4 breaks)
- [ ] Web: `npx tsc -b` passes with zero errors (primary type check for frontend)
- [ ] Web: `npm run build` passes with zero errors (both frontend and admin)
- [ ] Web: `useSearchParams()` wrapped in `<Suspense>` boundary
- [ ] Web: shadcn component APIs match actual installed version (check `render` vs `asChild`, variant values)
- [ ] Web UI works in light AND dark mode
- [ ] Web UI is responsive at 320px, 768px, 1024px, 1440px — tested at all breakpoints
- [ ] Mobile: styles in `*.styles.ts` files (no inline `style={{}}`)
- [ ] Mobile: component-based (no monolithic screen files, no raw View/Text blobs in screens)
- [ ] Mobile: brand theme constants used for all colors, spacing, fonts
- [ ] Mobile: e2e tests with Detox/Maestro following user journeys
- [ ] Relevant skills were consulted before implementation
- [ ] Security review completed on sensitive code (DAST scan for auth/payment endpoints)
- [ ] Database queries are optimized (indexes, no loops, bulk ops)
