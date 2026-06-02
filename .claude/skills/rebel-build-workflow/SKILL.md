---
name: rebel-build-workflow
description: Use when implementing any laravel-rebel-* package (core, email-otp, bridge-fortify, step-up, channels, channel-twilio, admin-api, admin, sessions, recovery, ai-guard, auth meta). Encodes the mandatory engineering workflow — one PR per macro-task, local loop per sub-task (Pest + PHPStan max + Pint + Playwright-if-UI + local Copilot review), GitHub gate (CI + @copilot reviewer) only at macro→main, LESSON.md/PROGRESS.md upkeep, didactic READMEs, tag+release.
---

# Rebel build workflow

You are building the `padosoft/laravel-rebel-*` enterprise auth suite. Follow this exactly.

## Before anything
1. Read `docs/LESSON.md` (knowledge accumulato) — and pass it to any subagent you spawn.
2. Read `docs/PROGRESS.md` — resume from there.
3. Read `AGENTS.md` (rules) and `docs/IMPLEMENTATION-PLAN.md` (full plan).

## Stack
Laravel 12+13, PHP 8.3/8.4/8.5. `illuminate/support: ^12.0|^13.0`, `php: ^8.3`. Testbench ^10|^11, Pest 4, Larastan 3 (PHPStan **max**), Pint (`laravel`), spatie/laravel-package-tools. Namespace `Padosoft\Rebel\...`.

## The loop (per sub-task, LOCAL, no PR)
1. Implement + guardrails: **Pest for all logic**; if UI (Blade/JS) → **Vite build + Playwright for every interaction**; code-only → no Playwright.
2. Green locally: `composer test`, `composer phpstan`, `composer pint --test`, (UI) `npm run build` + `npx playwright test`.
3. **Local Copilot review**: `git diff origin/main...HEAD` (big → temp file) → `copilot --yolo -p "/review …"` (**never** bare `copilot`). Fix until 0 relevant comments. Helper: `scripts/cr.ps1`.
4. Commit on the macro branch. Update `docs/PROGRESS.md` (+ `docs/LESSON.md` if learned something).

## The gate (once per macro-task, PR macro→main)
`git push` → `gh pr create` → `gh pr edit <n> --add-reviewer @copilot` (verify started) → wait CI green + Copilot comments → merge `--squash` (or fix-loop) → update `LESSON.md` → `git tag vX.Y.Z` + `gh release create`. Helper: `scripts/pr.ps1`.

## Non-negotiables
- One branch + one PR per macro-task. Sub-tasks are local commits.
- Every sub-task has objective + impl details + **guardrails** (tests; Playwright if UI).
- **README final step, DIDACTIC**: a junior/non-security-expert must instantly get what it does, how it works (step-by-step + ASCII), how to install, every config option (table), with **many examples** (≥4-6). `core` and meta `auth` READMEs explain the **whole ecosystem** (package map + DAG + end-to-end flows).
- Respect `docs/adr/ADR-0005-design-lock.md` (security decisions). Never log OTP/secrets.
- `copilot` only with `-p`. Update PROGRESS/LESSON continuously.
