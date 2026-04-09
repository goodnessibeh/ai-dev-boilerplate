# [Project Name] — Agent Coordination, Teams & Swarm Protocol

**Version:** 1.0
**Date:** April 2026
**Purpose:** Ensures all agents (backend, frontend, mobile, AI, DB) produce code that is perfectly synchronized — zero contract mismatches, zero naming conflicts, zero migration collisions.

> **Every agent MUST read this document before writing any code.**

---

## 1. Agent Teams

### Team Structure

Each feature is built by a coordinated team of agents. No agent works in isolation.

```
┌─────────────────────────────────────────────────────┐
│                  LEAD AGENT                          │
│  Owns the feature. Reads PRD. Creates contracts.     │
│  Coordinates all sub-agents. Validates integration.  │
└──────────────────────┬──────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
   ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
   │ Backend │   │ Frontend│   │ Mobile  │
   │ Agent   │   │ Agent   │   │ Agent   │
   └────┬────┘   └────┬────┘   └────┬────┘
        │              │              │
   ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
   │   DB    │   │   UI    │   │   UI    │
   │ Agent   │   │ Review  │   │ Review  │
   └─────────┘   └─────────┘   └─────────┘
```

| Agent Role | Responsibility | Reads | Produces |
|-----------|---------------|-------|----------|
| **Lead Agent** | Feature coordination, contract authoring | PRD, Build Plan, Engineering Standards | Contract file, task breakdown |
| **Backend Agent** | Models, serializers, views, services, tests | Contract, Engineering Standards, senior-security, database-optimizer | API endpoints, migrations, tests |
| **Frontend Agent** | Next.js pages, components, hooks, services | Contract, Engineering Standards, frontend-design | Pages, components, API calls, tests |
| **Mobile Agent** | React Native screens, components, services | Contract, Engineering Standards | Screens, components, API calls |
| **DB Agent** | Model review, query optimization, migration review | Contract, database-optimizer agent | Index recommendations, query reviews |
| **Security Agent** | Threat model, input validation, auth review | Contract, senior-security skill | Security review report |
| **QA Agent** | Test strategy, edge cases, integration tests | Contract, qa-testing skill | Test plans, test cases |

---

## 2. The Contract System

### What Is a Contract?

A **contract** is a single source of truth file that defines the exact interface between backend and frontend for a specific feature. It is written BEFORE any implementation begins. Both backend and frontend agents read from this contract — never from assumptions.

### Contract Location

```
docs/contracts/
├── accounts.contract.ts
├── opportunities.contract.ts
├── mentorship.contract.ts
├── resources.contract.ts
├── kids.contract.ts
├── ai_assistant.contract.ts
├── payments.contract.ts
├── notifications.contract.ts
├── partners.contract.ts
├── analytics.contract.ts
└── _enums.contract.ts          # Shared enum definitions (single source of truth)
```

### Contract File Format

Every contract is a TypeScript file that defines:
1. **Enums** (imported from `_enums.contract.ts`)
2. **Request types** (what the frontend sends)
3. **Response types** (what the backend returns)
4. **Endpoint definitions** (method, URL, auth, request, response)

```typescript
// docs/contracts/opportunities.contract.ts

import {
  OpportunityCategory,
  OpportunityStatus,
  IpArea,
  UserCategory,
  ApplicationStatus,
} from "./_enums.contract";

// ============================================================
// RESPONSE TYPES (what backend returns)
// ============================================================

export interface OpportunityListItem {
  id: number;
  title: string;
  slug: string;
  category: OpportunityCategory;
  provider_name: string | null;
  target_countries: string[];
  ip_areas: IpArea[];
  deadline: string | null;           // ISO 8601
  is_featured: boolean;
  is_verified: boolean;
  status: OpportunityStatus;
  image_url: string | null;
  created_at: string;                // ISO 8601
}

export interface OpportunityDetail extends OpportunityListItem {
  description: string;
  eligibility: string;
  external_url: string;
  target_categories: UserCategory[];
  start_date: string | null;
  updated_at: string;
  is_saved: boolean;                 // Computed for authenticated user
  application_status: ApplicationStatus | null;
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    cursor: string | null;
    has_next: boolean;
    total_count: number;
  };
}

// ============================================================
// REQUEST TYPES (what frontend sends)
// ============================================================

export interface OpportunityListParams {
  category?: OpportunityCategory;
  country?: string;                  // ISO 3166-1 alpha-2
  ip_area?: IpArea;
  target_category?: UserCategory;
  status?: OpportunityStatus;
  search?: string;
  ordering?: string;                 // e.g. "-deadline", "created_at"
  cursor?: string;
}

export interface TrackApplicationRequest {
  status: ApplicationStatus;
  notes?: string;
}

// ============================================================
// ENDPOINT DEFINITIONS
// ============================================================

export const OPPORTUNITY_ENDPOINTS = {
  list: {
    method: "GET" as const,
    url: "/api/v1/opportunities/",
    auth: false,
    params: {} as OpportunityListParams,
    response: {} as PaginatedResponse<OpportunityListItem>,
  },
  recommended: {
    method: "GET" as const,
    url: "/api/v1/opportunities/recommended/",
    auth: true,
    params: {} as OpportunityListParams,
    response: {} as PaginatedResponse<OpportunityListItem>,
  },
  detail: {
    method: "GET" as const,
    url: "/api/v1/opportunities/:slug/",
    auth: false,
    params: {} as { slug: string },
    response: {} as OpportunityDetail,
  },
  save: {
    method: "POST" as const,
    url: "/api/v1/opportunities/:id/save/",
    auth: true,
    request: undefined,
    response: {} as { saved: boolean },
  },
  track: {
    method: "POST" as const,
    url: "/api/v1/opportunities/:id/track/",
    auth: true,
    request: {} as TrackApplicationRequest,
    response: {} as { id: number; status: ApplicationStatus },
  },
  saved: {
    method: "GET" as const,
    url: "/api/v1/opportunities/saved/",
    auth: true,
    response: {} as PaginatedResponse<OpportunityListItem>,
  },
  deadlines: {
    method: "GET" as const,
    url: "/api/v1/opportunities/deadlines/",
    auth: true,
    response: {} as PaginatedResponse<OpportunityListItem>,
  },
} as const;
```

### Contract Rules

1. **Contract is written FIRST** — before any backend or frontend code
2. **Backend serializer field names MUST match** the contract response types exactly
3. **Frontend TypeScript types MUST be generated from** or match the contract types exactly
4. **Field names are `snake_case`** in contracts, API responses, and frontend types — no camelCase conversion
5. **All enums are defined in `_enums.contract.ts`** and imported — never redefined inline
6. **Contract changes require updating BOTH sides** — a contract change triggers a backend + frontend update
7. **No ad-hoc fields** — if a field is not in the contract, it does not exist in the API or UI

---

## 3. Enum Convention — Single Source of Truth

### Master Enum File

All enums used anywhere in the system are defined in ONE file:

```typescript
// docs/contracts/_enums.contract.ts

// ============================================================
// NAMING CONVENTION:
//   - Enum names: PascalCase (e.g., OpportunityCategory)
//   - Enum values: UPPER_SNAKE_CASE (e.g., "CERTIFICATION")
//   - This is the ONLY place enums are defined
//   - Backend and frontend MUST use these exact values
// ============================================================

// --- User & Auth ---

export enum UserRole {
  ANONYMOUS = "ANONYMOUS",
  USER = "USER",
  PREMIUM_USER = "PREMIUM_USER",
  MENTOR = "MENTOR",
  PARTNER = "PARTNER",
  CONTENT_ADMIN = "CONTENT_ADMIN",
  SUPER_ADMIN = "SUPER_ADMIN",
}

export enum UserCategory {
  CREATIVE = "CREATIVE",
  FOUNDER = "FOUNDER",
  STUDENT = "STUDENT",
  PROFESSIONAL = "PROFESSIONAL",
  GOVERNMENT = "GOVERNMENT",
  EDUCATOR = "EDUCATOR",
}

export enum CareerStage {
  STUDENT = "STUDENT",
  EARLY_CAREER = "EARLY_CAREER",
  MID_CAREER = "MID_CAREER",
  SENIOR = "SENIOR",
  EXECUTIVE = "EXECUTIVE",
}

export enum Language {
  EN = "EN",
  FR = "FR",
  SW = "SW",
  HA = "HA",
  YO = "YO",
  AM = "AM",
}

// --- Intellectual Property ---

export enum IpArea {
  COPYRIGHT = "COPYRIGHT",
  TRADEMARK = "TRADEMARK",
  PATENT = "PATENT",
  TRADE_SECRET = "TRADE_SECRET",
  COMPETITION_LAW = "COMPETITION_LAW",
  GENERAL = "GENERAL",
}

// --- Opportunities ---

export enum OpportunityCategory {
  CERTIFICATION = "CERTIFICATION",
  INTERNSHIP = "INTERNSHIP",
  FELLOWSHIP = "FELLOWSHIP",
  SCHOLARSHIP = "SCHOLARSHIP",
  COMPETITION = "COMPETITION",
  GRANT = "GRANT",
  JOB = "JOB",
}

export enum OpportunityStatus {
  ACTIVE = "ACTIVE",
  EXPIRED = "EXPIRED",
  DRAFT = "DRAFT",
}

export enum ApplicationStatus {
  INTERESTED = "INTERESTED",
  APPLIED = "APPLIED",
  ACCEPTED = "ACCEPTED",
  REJECTED = "REJECTED",
}

// --- Mentorship ---

export enum MatchType {
  SMART_MATCH = "SMART_MATCH",
  MARKETPLACE_REQUEST = "MARKETPLACE_REQUEST",
}

export enum MatchStatus {
  PENDING = "PENDING",
  ACTIVE = "ACTIVE",
  COMPLETED = "COMPLETED",
  DECLINED = "DECLINED",
  CANCELLED = "CANCELLED",
}

export enum SessionType {
  ONE_ON_ONE = "ONE_ON_ONE",
  GROUP = "GROUP",
  COHORT = "COHORT",
}

export enum SessionStatus {
  SCHEDULED = "SCHEDULED",
  IN_PROGRESS = "IN_PROGRESS",
  COMPLETED = "COMPLETED",
  CANCELLED = "CANCELLED",
  NO_SHOW = "NO_SHOW",
}

export enum MentorAvailabilityStatus {
  AVAILABLE = "AVAILABLE",
  LIMITED = "LIMITED",
  UNAVAILABLE = "UNAVAILABLE",
}

export enum MentorCategory {
  IP_LAWYER = "IP_LAWYER",
  CREATIVE = "CREATIVE",
  FOUNDER = "FOUNDER",
  POLICY_EXPERT = "POLICY_EXPERT",
  ACADEMIC = "ACADEMIC",
  INDUSTRY = "INDUSTRY",
}

export enum GoalStatus {
  NOT_STARTED = "NOT_STARTED",
  IN_PROGRESS = "IN_PROGRESS",
  COMPLETED = "COMPLETED",
}

export enum CohortStatus {
  UPCOMING = "UPCOMING",
  ACTIVE = "ACTIVE",
  COMPLETED = "COMPLETED",
}

// --- Resources ---

export enum ResourceType {
  COUNTRY_GUIDE = "COUNTRY_GUIDE",
  HOW_TO = "HOW_TO",
  CREATIVE_GUIDE = "CREATIVE_GUIDE",
  STARTUP_GUIDE = "STARTUP_GUIDE",
  CHECKLIST = "CHECKLIST",
  EXTERNAL_LINK = "EXTERNAL_LINK",
}

// --- Kids ---

export enum GameType {
  IS_IT_YOURS = "IS_IT_YOURS",
  PROTECT_IT = "PROTECT_IT",
  QUIZ = "QUIZ",
}

// --- AI ---

export enum IpValuationType {
  CREATIVE_WORK = "CREATIVE_WORK",
  PATENT = "PATENT",
  ALGORITHM = "ALGORITHM",
  TRADEMARK = "TRADEMARK",
  TRADE_SECRET = "TRADE_SECRET",
}

export enum ValuationStatus {
  PENDING = "PENDING",
  PROCESSING = "PROCESSING",
  COMPLETED = "COMPLETED",
  FAILED = "FAILED",
}

export enum ChatRole {
  USER = "USER",
  ASSISTANT = "ASSISTANT",
}

// --- Payments ---

export enum SubscriptionInterval {
  MONTHLY = "MONTHLY",
  ANNUALLY = "ANNUALLY",
}

export enum SubscriptionStatus {
  ACTIVE = "ACTIVE",
  CANCELLED = "CANCELLED",
  PAST_DUE = "PAST_DUE",
  EXPIRED = "EXPIRED",
}

export enum PaymentType {
  SUBSCRIPTION = "SUBSCRIPTION",
  LISTING_FEE = "LISTING_FEE",
  ONE_TIME = "ONE_TIME",
}

export enum PaymentStatus {
  PENDING = "PENDING",
  SUCCESS = "SUCCESS",
  FAILED = "FAILED",
  REFUNDED = "REFUNDED",
}

// --- Notifications ---

export enum NotificationType {
  OPPORTUNITY_DEADLINE = "OPPORTUNITY_DEADLINE",
  SESSION_REMINDER = "SESSION_REMINDER",
  MATCH_REQUEST = "MATCH_REQUEST",
  SYSTEM = "SYSTEM",
  PAYMENT = "PAYMENT",
}

export enum DevicePlatform {
  IOS = "IOS",
  ANDROID = "ANDROID",
  WEB = "WEB",
}

// --- Partners ---

export enum PartnerType {
  IP_OFFICE = "IP_OFFICE",
  LAW_FIRM = "LAW_FIRM",
  UNIVERSITY = "UNIVERSITY",
  NGO = "NGO",
  DEVELOPMENT_AGENCY = "DEVELOPMENT_AGENCY",
  GOVERNMENT = "GOVERNMENT",
}

export enum PartnerTier {
  BASIC = "BASIC",
  PROFESSIONAL = "PROFESSIONAL",
  ENTERPRISE = "ENTERPRISE",
}

export enum PartnerMemberRole {
  ADMIN = "ADMIN",
  EDITOR = "EDITOR",
  VIEWER = "VIEWER",
}

// --- Analytics ---

export enum UserAction {
  VIEW_OPPORTUNITY = "VIEW_OPPORTUNITY",
  SAVE_OPPORTUNITY = "SAVE_OPPORTUNITY",
  APPLY_OPPORTUNITY = "APPLY_OPPORTUNITY",
  BOOK_SESSION = "BOOK_SESSION",
  VIEW_RESOURCE = "VIEW_RESOURCE",
  PLAY_GAME = "PLAY_GAME",
  CHAT_AI = "CHAT_AI",
  REQUEST_VALUATION = "REQUEST_VALUATION",
}
```

### Enum Mapping to Django

Backend MUST mirror these exact values using Django `TextChoices`:

```python
# backend/apps/common/enums.py
# AUTO-GENERATED FROM docs/contracts/_enums.contract.ts
# DO NOT EDIT MANUALLY — update the contract, then regenerate

from django.db import models


class UserRole(models.TextChoices):
    ANONYMOUS = "ANONYMOUS", "Anonymous"
    USER = "USER", "User"
    PREMIUM_USER = "PREMIUM_USER", "Premium User"
    MENTOR = "MENTOR", "Mentor"
    PARTNER = "PARTNER", "Partner"
    CONTENT_ADMIN = "CONTENT_ADMIN", "Content Admin"
    SUPER_ADMIN = "SUPER_ADMIN", "Super Admin"


class UserCategory(models.TextChoices):
    CREATIVE = "CREATIVE", "Creative"
    FOUNDER = "FOUNDER", "Founder"
    STUDENT = "STUDENT", "Student"
    PROFESSIONAL = "PROFESSIONAL", "Professional"
    GOVERNMENT = "GOVERNMENT", "Government"
    EDUCATOR = "EDUCATOR", "Educator"


# ... same pattern for ALL enums
```

### Enum Rules

1. **Values are always `UPPER_SNAKE_CASE`** — in contracts, in Django, in TypeScript, in the database, in API responses
2. **Enum names are always `PascalCase`** — `OpportunityCategory`, not `opportunity_category`
3. **`_enums.contract.ts` is the single source of truth** — Django `TextChoices` mirror it exactly
4. **Backend stores the UPPER_SNAKE_CASE string** in the database column (not integers, not lowercase)
5. **Frontend sends and receives UPPER_SNAKE_CASE strings** — no transformation layer
6. **Adding a new enum value** requires updating: (a) `_enums.contract.ts`, (b) `backend/apps/common/enums.py`, (c) migration if model field choices changed
7. **Never define choices inline on a model field** — always import from `apps.common.enums`

---

## 4. Field Naming Convention

### The Universal Rule

**All field names are `snake_case` everywhere:**

| Layer | Convention | Example |
|-------|-----------|---------|
| Database column | `snake_case` | `created_at`, `is_featured` |
| Django model field | `snake_case` | `created_at`, `is_featured` |
| DRF serializer field | `snake_case` | `created_at`, `is_featured` |
| API JSON response | `snake_case` | `"created_at": "2026-04-01"` |
| API JSON request | `snake_case` | `{"first_name": "Amara"}` |
| Contract type property | `snake_case` | `created_at: string` |
| Frontend TypeScript | `snake_case` | `opportunity.created_at` |
| React Native | `snake_case` | `opportunity.created_at` |
| URL params | `snake_case` | `?ip_area=COPYRIGHT` |

**No camelCase conversion anywhere.** The frontend uses `snake_case` to match the API. This eliminates an entire class of bugs.

### Forbidden Patterns

```typescript
// WRONG — camelCase in frontend
interface Opportunity {
  createdAt: string;       // ❌ NO
  isFeature: boolean;      // ❌ NO
  ipAreas: string[];       // ❌ NO
}

// CORRECT — snake_case matching API
interface Opportunity {
  created_at: string;      // ✅ YES
  is_featured: boolean;    // ✅ YES
  ip_areas: string[];      // ✅ YES
}
```

```python
# WRONG — inconsistent naming
class OpportunitySerializer(serializers.ModelSerializer):
    providerName = serializers.CharField()    # ❌ NO camelCase
    IPAreas = serializers.ListField()         # ❌ NO PascalCase

# CORRECT — snake_case
class OpportunitySerializer(serializers.ModelSerializer):
    provider_name = serializers.CharField()   # ✅ YES
    ip_areas = serializers.ListField()        # ✅ YES
```

---

## 5. Migration Coordination Protocol

### Migration Naming Convention

```
NNNN_appname_description.py
```

- `NNNN` — Django auto-generated sequence number
- `appname` — the app label (e.g., `opportunities`)
- `description` — human-readable snake_case description

Examples:
```
0001_accounts_initial.py
0002_accounts_add_mentor_profile.py
0003_accounts_add_linkedin_url_to_profile.py
0001_opportunities_initial.py
0002_opportunities_add_deadline_index.py
```

### Migration Ordering Rules

Migrations are created in a strict order to prevent conflicts:

1. **`common` app first** — base models, enums, shared mixins
2. **`accounts` app second** — User model must exist before any ForeignKey references
3. **All other apps** — in dependency order (check `ForeignKey` targets)
4. **Cross-app dependencies** — declared explicitly in `dependencies = [("accounts", "0001_initial")]`

### Migration Determinism Rules

1. **One migration per logical change** — don't combine unrelated model changes in one migration
2. **Never edit a migration that has been applied** — create a new one
3. **Always run `makemigrations` with a `--name` flag:**
   ```bash
   python manage.py makemigrations opportunities --name add_deadline_index
   ```
4. **Every migration must be reversible** — include `RunPython` reverse operations
5. **No `RunPython` data migrations without explicit rollback functions**
6. **Indexes must use `AddIndex` (not inline `db_index`)** for new indexes on existing tables — allows `CONCURRENTLY` when needed
7. **Non-nullable field additions MUST include a default:**
   ```python
   # WRONG
   migrations.AddField(
       model_name="opportunity",
       name="priority",
       field=models.IntegerField(),  # ❌ Will fail on existing rows
   )

   # CORRECT
   migrations.AddField(
       model_name="opportunity",
       name="priority",
       field=models.IntegerField(default=0),  # ✅
   )
   ```

### Migration Conflict Resolution

When multiple agents create migrations for the same app concurrently:

1. **Merge migrations** using `python manage.py makemigrations --merge`
2. **Never manually edit dependency graphs** — use the merge command
3. **The Lead Agent is responsible** for checking migration conflicts before marking a feature complete
4. **Run `python manage.py migrate --check`** to verify no unapplied migrations exist

### Pre-Migration Checklist

Before creating any migration:

- [ ] Model field uses enum from `apps.common.enums` (not inline choices)
- [ ] Field name matches the contract type
- [ ] Foreign keys have `on_delete` explicitly set (never default)
- [ ] ArrayFields have `base_field` type specified
- [ ] JSONField has `default=dict` or `default=list` (never `default={}`)
- [ ] New non-nullable fields have defaults
- [ ] Index added for fields used in filters/ordering
- [ ] Migration has a descriptive `--name`

---

## 6. Swarm Protocol — Multi-Agent Coordination

### When Multiple Agents Work Simultaneously

When a feature requires backend, frontend, and mobile agents working in parallel:

```
┌─────────────────────────────────────────────────────────────┐
│                     SWARM SEQUENCE                           │
│                                                              │
│  Step 1: Lead Agent creates contract                         │
│          ↓                                                   │
│  Step 2: Lead Agent creates task breakdown                   │
│          ↓                                                   │
│  Step 3: Backend Agent implements API (reads contract)       │
│          ↓ (backend must complete first)                     │
│  Step 4: Frontend + Mobile agents implement UI (in parallel) │
│          ↓                                                   │
│  Step 5: Lead Agent runs integration validation              │
│          ↓                                                   │
│  Step 6: QA Agent runs test suite                            │
│          ↓                                                   │
│  Step 7: Security Agent reviews                              │
└─────────────────────────────────────────────────────────────┘
```

### Handoff Between Agents

When one agent hands work to another:

1. **Write what was done** — list of files created/modified
2. **Write what is expected next** — specific tasks for the receiving agent
3. **Reference the contract** — receiving agent MUST read the contract, not guess
4. **List any deviations from contract** — if something changed during implementation, document it and update the contract

### Agent Communication Rules

1. **Agents do NOT communicate directly** — they communicate through:
   - Contract files (`docs/contracts/`)
   - Task updates (TaskCreate/TaskUpdate)
   - Handoff files (`handoff/`)
   - Code comments (only when clarifying non-obvious implementation decisions)

2. **No agent may add a field that is not in the contract** — if a field is needed, update the contract first

3. **No agent may change an enum value** without updating `_enums.contract.ts` first

4. **No agent may rename a URL pattern** without updating the contract endpoint definition first

---

## 7. Integration Validation Checklist

Before any feature is marked complete, the Lead Agent (or any agent finishing a feature) MUST verify:

### Backend ↔ Contract
- [ ] Every serializer field name matches the contract response type
- [ ] Every enum value in serializer choices matches `_enums.contract.ts`
- [ ] Every URL pattern matches the contract endpoint URL
- [ ] Every HTTP method matches the contract
- [ ] Request body validation accepts exactly the fields in the contract request type
- [ ] Response JSON structure matches the contract response type (run test)

### Frontend ↔ Contract
- [ ] Every TypeScript type matches the contract (ideally imported from contract)
- [ ] Every API call URL matches the contract endpoint
- [ ] Every enum usage matches `_enums.contract.ts` values
- [ ] Every request payload sends exactly the fields the contract specifies
- [ ] Every response is typed with the contract response type

### Frontend ↔ Backend (End-to-End)
- [ ] Frontend can successfully call every backend endpoint
- [ ] Enum values sent by frontend are accepted by backend
- [ ] Enum values returned by backend render correctly in frontend
- [ ] Pagination params work correctly
- [ ] Error responses are handled (400, 401, 403, 404, 500)
- [ ] Auth token flow works (login → store → send in header → refresh)

### Mobile ↔ Contract
- [ ] Same checks as Frontend ↔ Contract
- [ ] Offline sync doesn't break enum values
- [ ] Deep link URLs match routing

### Migrations
- [ ] `python manage.py migrate --check` passes
- [ ] No migration conflicts
- [ ] All enum choices in models use `apps.common.enums`
- [ ] All field names match the contract

---

## 8. File Ownership Map

To prevent agents from stepping on each other's work:

| File/Directory | Owning Agent | Other Agents |
|---------------|-------------|-------------|
| `docs/contracts/*.contract.ts` | Lead Agent | Read-only for all others |
| `docs/contracts/_enums.contract.ts` | Lead Agent | Read-only for all others |
| `backend/apps/common/enums.py` | Backend Agent | Read-only for frontend/mobile |
| `backend/apps/{app}/models/` | Backend Agent | Read-only for all others |
| `backend/apps/{app}/serializers/` | Backend Agent | Read-only for all others |
| `backend/apps/{app}/views/` | Backend Agent | Read-only for all others |
| `backend/apps/{app}/tests/` | Backend Agent + QA Agent | — |
| `frontend/features/{feature}/` | Frontend Agent | Read-only for mobile |
| `frontend/components/ui/` | shadcn CLI (auto-generated) | No manual edits |
| `admin/features/{feature}/` | Frontend Agent | — |
| `mobile/src/{feature}/` | Mobile Agent | Read-only for frontend |
| `handoff/` | Lead Agent | All agents append |

### Conflict Rules

- **Two agents MUST NOT edit the same file** in the same session
- If a file needs changes from multiple agents, the Lead Agent sequences the work
- If a conflict occurs, the contract is the tiebreaker — the implementation that matches the contract wins

---

## 9. Error Response Contract

All API error responses follow this exact shape:

```typescript
// Standard error response — ALL endpoints
interface ApiError {
  error: {
    code: string;              // Machine-readable: "VALIDATION_ERROR", "NOT_FOUND", etc.
    message: string;           // Human-readable message
    details: Record<string, string[]> | null;  // Field-level errors for 400s
  };
}

// Error codes (exhaustive list)
export enum ErrorCode {
  VALIDATION_ERROR = "VALIDATION_ERROR",
  NOT_FOUND = "NOT_FOUND",
  UNAUTHORIZED = "UNAUTHORIZED",
  FORBIDDEN = "FORBIDDEN",
  RATE_LIMITED = "RATE_LIMITED",
  CONFLICT = "CONFLICT",
  INTERNAL_ERROR = "INTERNAL_ERROR",
  PAYMENT_REQUIRED = "PAYMENT_REQUIRED",
  SERVICE_UNAVAILABLE = "SERVICE_UNAVAILABLE",
}
```

**Backend** must use a custom exception handler that outputs this exact format.
**Frontend** must type all catch blocks with `ApiError`.
**Mobile** must use the same `ApiError` type.

---

## 10. Date & Time Contract

| Context | Format | Example |
|---------|--------|---------|
| API response (datetime) | ISO 8601 with timezone | `"2026-04-01T14:30:00Z"` |
| API response (date only) | ISO 8601 date | `"2026-04-01"` |
| API response (time only) | 24-hour format | `"14:30:00"` |
| API request (datetime) | ISO 8601 | `"2026-04-01T14:30:00Z"` |
| Database storage | UTC always | `timestamp with time zone` |
| Frontend display | Localized via `Intl.DateTimeFormat` | User's timezone |
| Mobile display | Localized via device locale | User's timezone |

**Rule:** Backend stores and returns UTC. Frontend/Mobile converts for display. No timezone logic in the backend beyond storing UTC.

---

## 11. Pagination Contract

All list endpoints use cursor-based pagination with this exact shape:

```typescript
// Request params
interface PaginationParams {
  cursor?: string;             // Opaque cursor string from previous response
  page_size?: number;          // Default 20, max 100
}

// Response wrapper
interface PaginatedResponse<T> {
  data: T[];
  meta: {
    cursor: string | null;     // null = no more pages
    has_next: boolean;
    total_count: number;
  };
}
```

**Backend** must implement this using DRF `CursorPagination` with a custom response format.
**Frontend/Mobile** must handle `has_next` for infinite scroll and `cursor` for next page requests.

---

## 12. Dynamic Testing Protocol

### All Tests Must Be Dynamic

Every test must exercise **real running code** — real HTTP requests, real browser interactions, real database operations. No test may only check imports, class existence, or static structure.

### Test Types Required Per Layer

| Layer | Runner | Dynamic Requirement |
|-------|--------|-------------------|
| Backend API | `pytest` + DRF `APIClient` | Real HTTP requests (`client.get()`, `client.post()`). Assert status codes, response bodies, DB state. |
| Backend Services | `pytest` + factory_boy | Call services with factory-created DB data. Assert DB mutations. |
| Frontend UI | Playwright | Real browser: navigate pages, click buttons, fill forms, assert visible content. |
| Frontend API | Vitest + MSW | Mock API server (MSW) returning contract-shaped responses. Assert components render data. |
| Security (DAST) | OWASP ZAP / Nuclei | Real HTTP attacks against running server. Auth bypass, injection, header checks. |
| Integration | pytest (backend) / Playwright (frontend) | Full user journeys crossing multiple endpoints. |

### User Journey Test Structure

Every test file follows user journeys — simulating what a real person does:

**Backend pattern:**
```python
class TestUserRegistrationJourney:
    """Complete registration flow: register → verify → login → profile."""

    def test_register_creates_user(self, api_client, db):
        response = api_client.post("/api/v1/auth/register/", {...})
        assert response.status_code == 201
        assert User.objects.filter(email="test@example.com").exists()

    def test_unverified_user_has_limited_access(self, api_client, db):
        # register, then try to access protected endpoint
        # assert 403 with appropriate error code

    def test_verify_email_unlocks_access(self, auth_client, db):
        # verify email, then access protected endpoint
        # assert 200
```

**Frontend pattern:**
```typescript
test.describe("Registration Journey", () => {
  test("new user registers and completes onboarding", async ({ page }) => {
    await page.goto("/register");
    await page.fill("[name=email]", "new@user.com");
    await page.fill("[name=password]", "SecureP@ss1");
    await page.click("button[type=submit]");
    await expect(page).toHaveURL("/onboarding");
    // ... complete onboarding steps
    await expect(page).toHaveURL("/opportunities");
  });
});
```

### DAST Scan Requirements

Run DAST before marking these features complete:
- Authentication (login, register, password reset)
- Payments (Paystack webhook, subscription endpoints)
- File uploads (avatar, IP documents)
- Any endpoint handling user-generated content

```bash
# In CI or before security-sensitive feature merge
docker run -t zaproxy/zap-stable zap-baseline.py \
  -t http://localhost:8000/api/v1/ \
  -r zap_report.html
```

### File Size Check in Tests

Every test run should validate no source file exceeds 300 lines. Add this as a CI check:

```bash
# Fail if any Python/TS/TSX file exceeds 300 lines
find backend/ frontend/ admin/ -name "*.py" -o -name "*.ts" -o -name "*.tsx" | \
  xargs wc -l | awk '$1 > 300 && !/total/ {print "OVER 300 LINES:", $0; exit 1}'
```

---

## Quick Reference Card

```
ENUM VALUES:     UPPER_SNAKE_CASE     (e.g., "CERTIFICATION", "SMART_MATCH")
ENUM NAMES:      PascalCase           (e.g., OpportunityCategory)
FIELD NAMES:     snake_case           (e.g., created_at, ip_areas)
URL PATHS:       kebab-case           (e.g., /api/v1/opportunities/saved/)
FILE NAMES:      snake_case           (e.g., opportunity_list.py, useOpportunities.ts)
COMPONENT NAMES: PascalCase           (e.g., OpportunityCard.tsx)
CSS CLASSES:     Tailwind utility     (e.g., "flex items-center gap-2")
DATE FORMAT:     ISO 8601 UTC         (e.g., "2026-04-01T14:30:00Z")
PAGINATION:      Cursor-based         (e.g., ?cursor=abc&page_size=20)
ERRORS:          { error: { code, message, details } }
```
