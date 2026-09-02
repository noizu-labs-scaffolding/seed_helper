# CLAUDE.md — seed_helper

Guidance for Claude Code. Monorepo ops → `../../../../../CLAUDE.md` (trl-infra root).

## Identity

Elixir seeding helper from the noizu-labs-scaffolding family, used by app seed/liquibase flows (e.g. promptornot, pos_app). Utility lib — keep minimal and additive.

## Stack & Commands

Elixir. `mix deps.get && mix compile`; `mix test`; `mix format`, `mix credo`.

## Gotchas

- Raw SQL paths: strict `PostgrexTypes` **rejects string uuids** — cast properly.
- Seed ordering matters for consumers' Liquibase/Ecto flows — document any new seed stages.

## Universal Rules (compressed)

- **Trinity Protocol REQUIRED**: Orientation → Friction → Response (full text: monorepo `protocols/the-trinity-protocol.md`).
- **No shell in main thread** — delegate to taskers.
- **Worktrees**: all work on worktrees; `epic.<group>` consolidation branches off `develop`; squash-PR provenance into epics.
- MAIN checkout owns `deps/_build`; worktrees symlink deps (absolute path).
