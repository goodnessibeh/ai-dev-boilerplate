# AI Dev Boilerplate

Production-grade engineering standards for AI-assisted development. Works with **any AI coding tool** — Claude Code, OpenAI Codex, Cursor, Windsurf, Cline, GitHub Copilot, Kimi, DeepSeek, and more.

Drop it into any project to get TDD, security-first development, multi-agent coordination, contract-first API design, and 129+ reference guides out of the box.

## What It Does

Every AI coding tool reads instruction files from your project. This boilerplate provides those files — pre-loaded with battle-tested engineering standards — so every AI session starts with the same quality bar, regardless of which tool you use.

It enforces:
- **Test-Driven Development** — tests first, user journey patterns, dynamic testing only
- **Security-Driven Development** — threat modeling, OWASP Top 10, DAST scanning
- **Contract-First APIs** — TypeScript contracts define interfaces before any code
- **No God Files** — 300-line hard limit, directory-based module structure
- **Consistent Naming** — `snake_case` fields, `UPPER_SNAKE_CASE` enums, `PascalCase` components
- **No Inline Styles** — CSS Modules (web), StyleSheet companion files (mobile)

## Quick Start

```bash
# Clone the boilerplate
git clone https://github.com/goodnessibeh/claude-dev-boilerplate.git

# Option A: Run the setup script
cd claude-dev-boilerplate
./setup.sh /path/to/your-project

# Option B: Copy manually
cp -r claude-dev-boilerplate/{.claude,.ai,CLAUDE.md,AGENTS.md,.cursorrules,.windsurfrules,.clinerules,.kimi,.deepseek,.github,handoff,docs} /path/to/your-project/
```

Then open `CLAUDE.md` and replace the `[Project Name]`, `[Your Name]`, and other placeholders with your project details.

## Supported AI Tools

| Tool | Instruction File | Auto-Read |
|------|-----------------|-----------|
| **Claude Code** | `CLAUDE.md` + `.claude/` (skills, commands, agents, hooks) | Yes |
| **OpenAI Codex** | `AGENTS.md` | Yes |
| **Cursor** | `.cursorrules` | Yes |
| **Windsurf** | `.windsurfrules` | Yes |
| **Cline** | `.clinerules` | Yes |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Yes |
| **Kimi** | `.kimi` (point it to `CLAUDE.md` for full standards) | Manual |
| **DeepSeek** | `.deepseek` (point it to `CLAUDE.md` for full standards) | Manual |
| **Any other tool** | Point it to read `CLAUDE.md` | Manual |

**How it works:**
- `CLAUDE.md` is the **single source of truth** — all engineering standards live here
- Each provider file (`.cursorrules`, `AGENTS.md`, etc.) contains a quick-reference summary and points to `CLAUDE.md` for the full rules
- `.ai/` is a symlink to `.claude/` so reference guide paths work regardless of which tool you use

## What's Included

### Engineering Standards (`CLAUDE.md`)

| Area | What It Enforces |
|------|-----------------|
| **TDD** | Write tests first. Red, Green, Refactor. Every endpoint/component tested. |
| **SDD** | Threat model before implementation. OWASP Top 10. DAST scans. |
| **Architecture** | 300-line file limit. Directory-based modules. No monolithic files. |
| **Database** | N+1 prevention. Cursor pagination. Index optimization. Migration safety. |
| **Security** | Auth + authz on every endpoint. Rate limiting. Audit logging. No hardcoded secrets. |
| **Frontend** | CSS Modules (no inline styles). Mobile-first. Light + dark mode. WCAG 2.1 AA. |
| **Mobile** | StyleSheet companion files. Component-based screens. Detox/Maestro e2e tests. |
| **Naming** | snake_case fields, UPPER_SNAKE_CASE enums, PascalCase components everywhere. |
| **Git** | No AI tool names in commits. Always `git add .` from root. |
| **Testing** | Dynamic tests only. Real HTTP requests, real browser interactions. User journey patterns. |

### Reference Guides (129 files)

```
.ai/skills/
├── 01-Software-Web-Development/    # Frontend, MCP, Cloudflare, Stripe, webapp testing
├── 02-Context-Engineering-AI/      # Context optimization, prompt engineering, multi-agent
├── 03-Security/                    # Security code review, vibesec
├── 04-QA-Testing/                  # QA testing strategies
├── 05-Document-Processing/         # PDF, DOCX processing
├── 06-Meta-Process/                # Meta-level process guides
├── senior-security/                # Threat modeling, pen testing, crypto implementation
├── senior-qa/                      # Test automation, coverage analysis, e2e scaffolding
├── product-manager-toolkit/        # PRD templates, RICE prioritization
├── frontend-design/                # Production-grade UI design
├── web-perf/                       # Core Web Vitals, performance analysis
├── webapp-testing/                 # Playwright-based web app testing
├── stripe-integration/             # Payment processing patterns
├── mcp-builder/                    # MCP server development
├── test-driven-development/        # TDD workflow
├── verification-before-completion/ # Verify before claiming done
└── ...                             # 20+ more
```

### Command Guides (4)

| Command | Description |
|---------|------------|
| `ultra-think` | Multi-framework structured analysis with adversarial reasoning |
| `create-prd` | Generate Product Requirements Documents |
| `init-project` | Initialize new project with proper structure |
| `setup-development-environment` | Configure dev environment with tools and workflows |

### Agent Guides

| Agent | Description |
|-------|------------|
| `database-optimizer` | Query optimization, indexing, performance tuning (PostgreSQL, MySQL, MongoDB) |

### Hooks (Claude Code)

These auto-run hooks are configured in `.claude/settings.local.json` for Claude Code users:

| Hook | Trigger | What It Does |
|------|---------|-------------|
| **Auto-format** | After every file edit | Prettier (JS/TS/CSS), Black (Python), gofmt (Go), rustfmt (Rust) |
| **Dependency audit** | After editing package.json/requirements.txt | npm audit, safety check, cargo audit |
| **Secret detection** | After every file edit | semgrep, bandit, gitleaks, regex pattern matching |

### Multi-Agent Coordination (`docs/AGENT_COORDINATION.md`)

A complete protocol for multi-agent development:
- Team structure (Lead, Backend, Frontend, Mobile, DB, Security, QA agents)
- Contract system (TypeScript contracts define APIs before code)
- Enum conventions (single source of truth)
- Migration protocol (naming, ordering, conflict resolution)
- Swarm protocol (how agents hand off work)
- Integration validation checklists

### Session Handoff System (`handoff/`)

| Template | Purpose |
|----------|---------|
| `HANDOFF_TEMPLATE.md` | End-of-session handoff for continuity between sessions |
| `SESSION_MEMORY.md` | Persistent memory — architecture decisions, module status |
| `E2E_TESTING_GUIDE.md` | End-to-end testing patterns and strategies |

## Project Structure

```
your-project/
├── CLAUDE.md                          # Full engineering standards (source of truth)
├── AGENTS.md                          # Codex instruction file
├── .cursorrules                       # Cursor instruction file
├── .windsurfrules                     # Windsurf instruction file
├── .clinerules                        # Cline instruction file
├── .kimi                              # Kimi instruction file
├── .deepseek                          # DeepSeek instruction file
├── .github/
│   └── copilot-instructions.md        # GitHub Copilot instruction file
├── .claude/                           # Claude Code: skills, commands, agents, hooks
│   ├── settings.local.json            # Permissions, hooks, env vars
│   ├── scripts/context-monitor.py     # Context window monitor
│   ├── agents/database-optimizer.md
│   ├── commands/                      # ultra-think, create-prd, init-project, setup-dev-env
│   ├── skills/                        # 129 reference guide files
│   └── plugins/                       # Plugin marketplace
├── .ai -> .claude                     # Symlink (provider-agnostic path)
├── docs/
│   ├── AGENT_COORDINATION.md          # Multi-agent coordination protocol
│   └── contracts/
│       └── _enums.contract.ts         # Enum definitions template
├── handoff/
│   ├── HANDOFF_TEMPLATE.md
│   ├── SESSION_MEMORY.md
│   └── E2E_TESTING_GUIDE.md
└── setup.sh                           # Setup script for new projects
```

## Tech Stack Assumptions

This boilerplate defaults to the following stack, but the patterns adapt to anything:

| Layer | Default | Adaptable To |
|-------|---------|-------------|
| Backend | Django + DRF | FastAPI, Express, Rails, Go, etc. |
| Database | PostgreSQL | MySQL, MongoDB, etc. |
| Frontend | Next.js + TypeScript + shadcn/ui + Tailwind | React, Vue, Svelte, etc. |
| Mobile | React Native (Expo) | Flutter, SwiftUI, Kotlin |
| State | Zustand | Redux, Jotai, MobX |
| Testing | pytest + Playwright + Detox | Jest, Cypress, Maestro |

To adapt: update the relevant sections in `CLAUDE.md`. The principles (TDD, SDD, 300-line limit, naming conventions, contract-first) are universal.

## Self-Updating

`CLAUDE.md` includes **Boilerplate Adaptation Instructions** that tell any AI model to continuously update the document as the project evolves — replacing placeholders, adding project-specific sections, removing irrelevant ones. The standards file stays current, never stale.

## License

Free to use for any project. Individual skills and plugins retain their original licenses where applicable.
