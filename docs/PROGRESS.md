# PROGRESS.md — stato di avanzamento (Laravel Rebel)

> **Regola:** aggiornare ad OGNI sotto-task. Serve a riprendere esattamente da dove si è interrotto dopo una sessione chiusa bruscamente. Leggere insieme a `LESSON.md` all'avvio.

## Stato corrente
- **Sessione:** 2026-06-02
- **Round automode:** fino a `admin-api` incluso, poi STOP prima di `admin` (chiedere path template).
- **Macro-task in corso:** **T1 — core** (prossimo). T0 governance ✅ mergeato (PR #1).
- **Gate review:** `@copilot` GitHub non disponibile (vedi LESSON #4) → gate = **review Copilot LOCALE** (`scripts/cr.ps1`) + CI.

## Cosa sto facendo ORA
Avvio **T1 `laravel-rebel-core`**: skeleton (composer, ServiceProvider spatie, CI, pint/phpstan/pest) + ADR design-lock + value objects/contratti. Branch `feat/core`.

## Tabella macro-task (questo round)
| # | Package | Repo | Branch | Stato |
|---|---|---|---|---|
| T0 | governance | laravel-rebel-auth | chore/governance | ✅ done (PR #1) |
| T1 | core | laravel-rebel-core | feat/core | ⬜ da fare |
| T2 | email-otp | laravel-rebel-email-otp | feat/email-otp | ⬜ |
| T3 | bridge-fortify | laravel-rebel-bridge-fortify | feat/bridge-fortify | ⬜ |
| T4 | step-up | laravel-rebel-step-up | feat/step-up | ⬜ |
| T5a | channels | laravel-rebel-channels | feat/channels | ⬜ |
| T5b | channel-twilio | laravel-rebel-channel-twilio | feat/channel-twilio | ⬜ |
| T6 | admin-api | laravel-rebel-admin-api | feat/admin-api | ⬜ |
| ⏸️ | STOP prima di admin → chiedere path template | | | |

## Note di ripresa
- Piano completo: `docs/IMPLEMENTATION-PLAN.md` (questo repo) / `C:\Users\lopad\.claude\plans\synchronous-dazzling-lynx.md`.
- Workflow/DoD: `AGENTS.md`. Lezioni: `docs/LESSON.md`.
- Spec admin panel (per T7): `C:\xampp\htdocs\laravel-rebel-admin\docs\admin-panel-template-spec.md` (non committato).
