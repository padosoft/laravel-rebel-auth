# Changelog

All notable changes to `padosoft/laravel-rebel-auth` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-06-03

### Added

- Meta-package that installs and ties together the whole **Laravel Rebel** suite:
  `core`, `email-otp`, `step-up`, `bridge-fortify`, `channels`, `admin-api`,
  `admin`, `sessions`, `recovery`, and `ai-guard`.
- `suggest` entries for optional channel providers and bridges
  (`channel-twilio/vonage/bird/telegram/discord`,
  `bridge-passkeys/spatie-otp/laragear-2fa/otpz`, `bot-protection`).
- Flagship ecosystem README: capability card-battle (including Shopify), package
  map, dependency DAG, narrated end-to-end flows, and the Web Admin Panel section.
- Suite-wiring smoke test asserting a key service from every member package
  resolves from the container when the suite is installed together.

[0.1.0]: https://github.com/padosoft/laravel-rebel-auth/releases/tag/v0.1.0
