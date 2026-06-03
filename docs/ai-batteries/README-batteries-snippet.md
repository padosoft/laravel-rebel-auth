## 🔋 Vibe coding with batteries included

This package ships **AI batteries** — so you (and your AI agent) can extend it correctly on the
first try:

- **`CLAUDE.md`** — a concise AI working guide (purpose, conventions, architecture, how to extend,
  Definition of Done). Plain Markdown, so Claude Code, Cursor, Copilot and Codex all read it.
- **`AGENTS.md`** — the agent/workflow contract (branch → PR → CI → tag/release, the gates).
- **`.claude/skills/`** — invocable skills (at least `rebel-package-dev`) encoding the suite's
  TDD loop, the **PHPStan-level-max** recipes, the security/telemetry rules, and the release
  discipline.

Open the repo in your AI editor and just start — the rules, guardrails and extension recipes come
with it. PRs that follow the shipped `CLAUDE.md` pass CI (PHPStan max + Pest + Pint) and review the
first time around.
