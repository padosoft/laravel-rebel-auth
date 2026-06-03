# PROGRESS.md — stato di avanzamento (Laravel Rebel)

> **Regola:** aggiornare ad OGNI sotto-task. Serve a riprendere esattamente da dove si è interrotto dopo una sessione chiusa bruscamente. Leggere insieme a `LESSON.md` all'avvio.

## Stato corrente
- **Sessione:** 2026-06-03
- **Round automode:** **GOAL = vai al 100% di T13**, senza stop. Per `admin` (T7) costruisco la UI dal template utente `Laravel Rebel Admin.html` in `C:\Users\lopad\Downloads\laravel-rebel\laravel-rebel-web-panel`.
- **Secrets pronti (in `.env` git-ignored, MAI in md/commit):** Twilio in `laravel-rebel-channel-twilio/.env`, Mailtrap in `laravel-rebel-email-otp/.env`. Numero test utente: solo in `.env`. Repo `laravel-rebel-demo` clonato (T13).
- **Macro-task in corso:** **T3 — bridge-fortify** (PROSSIMO). T0/T1/T2/**T4** ✅ mergeati+rilasciati.
- **Ordine T3/T4 invertito:** `step-up` (T4) costruito PRIMA di `bridge-fortify` (T3) perché il bridge dipende dal contratto `StepUpDriver` definito in step-up.
- **⚠️ Naming stub esistenti (verificato da agente):** alcuni repo-skeleton già pushati usano namespace/provider DIVERSI dalla convenzione attesa — allinearsi a QUELLI quando si implementa:
  - `bridge-fortify` → namespace `Padosoft\Rebel\Bridge\Fortify`, provider `RebelFortifyBridgeServiceProvider` (NON `BridgeFortify`).
  - `channel-twilio` → namespace `Padosoft\Rebel\Channel\Twilio`, provider `RebelTwilioServiceProvider` (NON `ChannelTwilio`).
  - Gli altri (channels, admin-api, admin, sessions, recovery, ai-guard, auth) seguono la convenzione standard `Padosoft\Rebel\<Studly>` + `Rebel<Studly>ServiceProvider`.
- **Packagist:** tutti i 9 repo-skeleton (bridge-fortify, channels, channel-twilio, admin-api, admin, sessions, recovery, ai-guard, auth) hanno composer.json valido **già committato e pushato su origin/main** → registrabili ora.
- **Gate review:** `@copilot` reviewer SI usa via REST (`gh api ... /requested_reviewers -f "reviewers[]=copilot-pull-request-reviewer[bot]"`); LESSON #4 superato. Backup: review Copilot LOCALE (`scripts/cr.ps1`).

## Cosa sto facendo ORA
**T1 `core` ✅ v0.1.0** · **T2 `email-otp` ✅ v0.1.0** · **T4 `step-up` → PR #1 aperta** (15 test Pest verdi, PHPStan max, Pint; 8 fix da 2 round review Copilot locale: device binding simmetrico, assurance vs policy corrente, canonical JSON anti-injection, start() atomico, Aal::tryFrom fail-closed, subjectId fail-fast, TransactionContext validation; README didattico + .env.example + CHANGELOG; LICENSE→MIT).

**T4 step-up ✅ v0.1.0 mergeato+rilasciato.** **T3 bridge-fortify → PR #1 in gate** (CI verde, fix da review Codex+Copilot applicate, in attesa merge). Docs di core/email-otp/step-up tradotti in INGLESE (agenti background, pushati su main) + composer.json description EN.

**Prossimo dopo merge bridge-fortify: T5 `channels` + `channel-twilio`** (live Twilio). Nota naming stub: `channel-twilio` usa `Padosoft\Rebel\Channel\Twilio` + `RebelTwilioServiceProvider`.

## Tabella macro-task (questo round)
| # | Package | Repo | Branch | Stato |
|---|---|---|---|---|
| T0 | governance | laravel-rebel-auth | chore/governance | ✅ done (PR #1) |
| T1 | core | laravel-rebel-core | feat/core | ✅ done (v0.1.0) |
| T2 | email-otp | laravel-rebel-email-otp | feat/email-otp | ✅ done (v0.1.0) |
| T4 | step-up | laravel-rebel-step-up | feat/step-up | ✅ done (v0.1.0) |
| T3 | bridge-fortify | laravel-rebel-bridge-fortify | feat/bridge-fortify | ✅ done (v0.1.0) |
| T5a | channels | laravel-rebel-channels | feat/channels | ✅ done (v0.1.0) |
| T5b | channel-twilio | laravel-rebel-channel-twilio | feat/channel-twilio | ✅ done (v0.1.0, live test reale ok) |
| T6 | admin-api | laravel-rebel-admin-api | feat/admin-api | ✅ done (v0.1.0) |
| T7 | admin | laravel-rebel-admin | feat/admin | ✅ done (v0.1.0) — shell + Overview/Audit live; resto "endpoint pending" |
| T8a | sessions | laravel-rebel-sessions | feat/sessions | ✅ done (v0.1.0) |
| T8b | recovery | laravel-rebel-recovery | feat/recovery | ✅ done (v0.1.0) |
| T9 | ai-guard | laravel-rebel-ai-guard | feat/ai-guard | ✅ done (v0.1.0) |
| T10 | extra bridges/providers | (8 stub repos) | — | ⬜ on-demand (skeleton pushati, registrabili; impl fuori dal set prioritario) |
| T11 | auth (meta) | laravel-rebel-auth | feat/meta | 🔄 prossimo (flagship README) |
| T12 | harvest lessons | (tutti i repo) | — | ⬜ |
| T13 | demo | laravel-rebel-demo | — | ⬜ app integrazione |

**Nota T7 follow-up:** le 8 sezioni "endpoint pending" (funnels, channels, providers, devices, risk-rules, anomalies, ai, compliance) richiedono i rispettivi endpoint su `admin-api` (estendere admin-api in una minor) + widget JS + Playwright E2E. Spec completa in `laravel-rebel-admin/docs/admin-panel-template-spec.md`.

**✅ TUTTI i 21 package registrati su Packagist (2026-06-03).** Da ora: `composer require padosoft/laravel-rebel-<x>:^0.1` diretto, **niente più blocco `repositories` VCS** nei nuovi package (memoria `all-packages-on-packagist`).

**Template admin (T7):** `C:\Users\lopad\Downloads\laravel-rebel\laravel-rebel-web-panel\project\` — **SPA React/JSX** (Laravel Rebel Admin.html + app/shell/ui/charts/icons.jsx + pages-{monitor,investigate,intel,anomaly}.jsx + data.js + styles*.css + tweaks-panel.jsx) + spec `uploads/admin-panel-template-spec.md`. Da montare come pannello web del package -admin (Blade host + asset Vite, dati reali da admin-api).

## Note di ripresa
- Piano completo: `docs/IMPLEMENTATION-PLAN.md` (questo repo) / `C:\Users\lopad\.claude\plans\synchronous-dazzling-lynx.md`.
- Workflow/DoD: `AGENTS.md`. Lezioni: `docs/LESSON.md`.
- Spec admin panel (per T7): `C:\xampp\htdocs\laravel-rebel-admin\docs\admin-panel-template-spec.md` (non committato).
