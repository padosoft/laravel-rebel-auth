# CLAUDE.md — AI working guide for the Laravel Rebel suite

> This is the **meta-package** (`padosoft/laravel-rebel-auth`) that installs and wires the whole
> **Laravel Rebel** enterprise-auth suite. Working on any package with an AI agent (Claude Code,
> Cursor, Copilot, Codex)? Read this, then the package's own `CLAUDE.md`.

## The suite
An enterprise authentication control plane over Laravel Fortify: passwordless email-OTP &
passkey-first login (web + mobile via Sanctum), risk-based step-up with PSD2/SCA dynamic linking,
multi-channel verification (SMS/WhatsApp/voice) with anti-fraud + **delivery receipts**,
refresh-token rotation with reuse detection, device trust, recovery codes, deterministic anomaly
detection + advisory AI, a self-hosted **web admin panel**, and a unified, HMAC'd, country-aware
audit trail — modular, multi-tenant, PHPStan-max.

Packages: `core` (shared language: contracts, value objects, **AuditLogger**, keyed hashing,
tenancy) · `email-otp` · `step-up` · `bridge-fortify` · `channels` (+ `channel-twilio`) ·
`admin-api` · `admin` (the React SPA panel) · `sessions` · `recovery` · `ai-guard`. Each ships its
own `CLAUDE.md`.

## Conventions (every package)
`declare(strict_types=1)`, `final` classes, **PHPStan level max** (never suppress — fix the cause),
Pest + Testbench, Pint, spatie/laravel-package-tools, English README/CHANGELOG/.env.example with a
competitor card-battle incl. Shopify. See `.claude/skills/rebel-package-dev` for the loop +
PHPStan-max recipes + the security/telemetry rules.

## The rules that matter most
- **Security:** identifiers/IP/User-Agent are keyed HMACs (core `KeyedHasher`); never cleartext PII
  or OTPs/secrets in the audit (sanitized by `Redactor`).
- **Telemetry completeness (mandatory):** every channel/driver/bridge captures ALL telemetry that
  fills every panel section/field (sends, delivery receipts, cost, country, devices/sessions,
  anomalies). Record via the core `AuditLogger` (persisted to `rebel_auth_events`, never session;
  **configurable sync|queue**, Horizon-ready; configurable destination). Leave a field empty only
  if the driver can't supply it — and show an honest empty state, never fake data.
- **Release discipline:** one branch + one PR per change; CI matrix **PHP 8.3/8.4/8.5 × Laravel
  12/13** green; squash-merge; **`git tag vX.Y.Z` + `gh release create`** every time. Stay in
  `0.1.x` (`^0.1` excludes `0.2.0`).

## Where things live
- Plan + accumulated lessons: `docs/IMPLEMENTATION-PLAN.md`, `docs/PROGRESS.md`, `docs/LESSON.md`.
- AI batteries source-of-truth + rollout plan: `docs/ai-batteries/`.
- Workflow/DoD contract: `AGENTS.md`.

## Session start (read in this order)
1. `docs/LESSON.md` (accumulated know-how — applies to you and every subagent).
2. `docs/PROGRESS.md` (where we left off).
3. `docs/IMPLEMENTATION-PLAN.md` + `AGENTS.md` (the plan and the rules).

Reminders: `copilot` CLI only with `-p` (else it hangs); `php`/`node` run in PowerShell (Herd),
not the Bash tool; update `PROGRESS.md` per sub-task and `LESSON.md` whenever you learn something.
