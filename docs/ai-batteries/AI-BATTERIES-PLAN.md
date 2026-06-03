# Plan — "Vibe coding with batteries" for every Laravel Rebel package

> Final task of the build plan: turn the know-how accumulated across the build (see
> `docs/LESSON.md`) into **reusable rules, skills and `CLAUDE.md` files shipped inside every
> `padosoft/laravel-rebel-*` package**, so anyone doing AI-assisted ("vibe") coding on a package
> gets the conventions, guardrails and extension recipes for free. Each README advertises this as
> a plus: **"vibe coding with batteries included"**.

## What every package ships (the "batteries")

1. **`CLAUDE.md`** (repo root) — the AI working guide for THAT package: one-line purpose, the
   suite conventions, the package's architecture + extension points, and the DoD/workflow. Kept
   short and high-signal. (Also serves Cursor/Copilot/Codex — it's plain Markdown.)
2. **`AGENTS.md`** (repo root) — the agent/workflow contract (branch→PR→CI→tag/release, gates).
   Most repos already have one; it's aligned with `CLAUDE.md`.
3. **`.claude/skills/rebel-package-dev/SKILL.md`** — a shared, invocable skill encoding the
   suite's dev loop (TDD + PHPStan max + Pint + per-package PR + tag/release) and the
   PHPStan-max recipes. Plus, where it adds value, a **package-specific** skill (e.g.
   `add-a-channel-provider`, `add-an-admin-api-endpoint`, `record-an-audit-event`).
4. **README `## Vibe coding with batteries` section** — tells the community the package ships
   `CLAUDE.md` + skills/rules so an AI agent can extend it correctly on the first try.

## Canonical sources (this folder)
- `CLAUDE.template.md` — the per-package CLAUDE.md template (fill the `{{PACKAGE}}` / purpose /
  extension-points blocks).
- `SKILL.template.md` — the shared `rebel-package-dev` skill.
- `README-batteries-snippet.md` — the README section to paste into each package.

## Harvested know-how baked into the batteries (from LESSON.md + the build)
- **Conventions:** `final` classes, `declare(strict_types=1)`, **PHPStan level max** (never
  `@phpstan-ignore`/baseline — fix the root cause), Pest, Pint, spatie/laravel-package-tools
  provider, English README/CHANGELOG/.env.example, a competitor card-battle incl. Shopify.
- **PHPStan-max recipes:** `is_scalar($x) ? (string) $x : …` before string-casting `mixed`;
  `array<array-key, mixed>` for `json_decode(...)`; the container's `make('request')` is typed
  `Request` (no redundant `instanceof`); `cursor()` for memory-safe scans; `withoutGlobalScopes()`
  for cross-tenant admin reads; nested Eloquent `where` closures receive `Eloquent\Builder`;
  larastan view rule → `response()->view(...)`; `Aal::tryFrom()` (fail-closed); `@property` blocks
  on models; `--memory-limit=512M`.
- **Telemetry completeness (mandatory):** every channel/driver/bridge captures ALL telemetry that
  fills every panel section/field (delivery receipts, cost, country, devices/sessions, anomalies);
  skip a field only if the driver can't supply it, and show an honest empty state. Capture in the
  package via the core `AuditLogger` (persisted to `rebel_auth_events`, never session), with
  **configurable sync|queue** dispatch (Horizon-ready) and a configurable destination.
- **Audit context:** record IP + User-Agent as keyed HMACs; AAL/AMR per factor; **country** from a
  configurable request header (default `CF-IPCountry`). Channel sends/receipts as
  `channel.verification.started|delivered|approved|undelivered`.
- **Release discipline:** one branch + one PR per change; CI matrix **PHP 8.3/8.4/8.5 × Laravel
  12/13** green; squash-merge; **`git tag vX.Y.Z` + `gh release create`** every time. Stay within
  `0.1.x` (Composer `^0.1` excludes `0.2.0`, which would break dependents). CI pins BOTH
  `illuminate/contracts` AND `illuminate/support`; `composer check` uses `pint --test`.
- **Tooling gotchas:** `php`/`node` live in PowerShell (Herd), not the Bash tool; spatie
  `hasAssets()` publishes to `public/vendor/{shortName}` (strips the `laravel-` prefix); package
  migrations load by filename order (`loadMigrationsFrom`) — don't let an `add_*` migration sort
  before its `create_*`; build front-end without a native bundler via Babel-standalone + React UMD
  when the host blocks native binaries; use Mailtrap (or `MAIL_MAILER=log`) for OTP e2e.

## Rollout
Apply the four batteries to **every** package (core, email-otp, step-up, bridge-fortify, channels,
channel-twilio, admin-api, admin, sessions, recovery, ai-guard, the `auth` meta, and the demo),
one branch + PR per repo, docs-only (no version bump needed for docs; Packagist serves the README
from the default branch).
