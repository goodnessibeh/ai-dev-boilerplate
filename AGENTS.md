# OpenAI Codex — Project Instructions

> This file is for **OpenAI Codex CLI**. The canonical engineering standards are in `CLAUDE.md`.
> Both files are kept in sync. Read `CLAUDE.md` for the full, authoritative engineering standards.

## Instructions

You MUST read and follow ALL rules in `CLAUDE.md` before writing any code. That file contains:

- Development methodology (TDD, Security-Driven Development)
- Code architecture rules (300-line limit, directory-based modules)
- Database optimization standards
- Security standards (auth, validation, rate limiting on every endpoint)
- UI standards (CSS Modules, mobile-first, dark mode)
- Naming conventions (snake_case fields, UPPER_SNAKE_CASE enums, PascalCase components)
- Git commit rules
- Testing requirements (dynamic tests only, user journey patterns)
- Code quality checklist

## Key Files to Read

1. `CLAUDE.md` — Full engineering standards (START HERE)
2. `handoff/SESSION_MEMORY.md` — Project state and decisions
3. `docs/AGENT_COORDINATION.md` — Multi-agent coordination, contracts, enums
4. `docs/contracts/_enums.contract.ts` — Enum definitions (single source of truth)
5. `.ai/skills/` — Reference guides for security, testing, frontend, database work

## Non-Negotiable Rules

- Write tests FIRST (TDD)
- No file over 300 lines
- No inline styles (CSS Modules on web, StyleSheet files on mobile)
- No N+1 queries
- No hardcoded secrets
- All fields are `snake_case`, all enums are `UPPER_SNAKE_CASE`
- No AI tool names in commit messages
