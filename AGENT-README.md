# AGENT-README

> Orientation for AI coding agents working in this repo. Human docs: README.md.

## Type

elixir-lib

## Purpose

SeedHelper: tracked/incremental Ecto seeding — versioned `seed/2` blocks that run once, `requires_seed` blocks that queue until prerequisites are applied, `if_env` environment gating, and handle set/lookup for referencing generated ids across seeds.

## Stack

Elixir (~> 1.10). Deps: ecto_sql, elixir_uuid; ex_doc for dev. Hex app `:seed_helper` v0.1.1.

## Dev mode

```bash
mix deps.get && mix compile
```

## Ports / URLs

- none (library/CLI)

## Tests

```bash
mix test
```

## Gotchas

- The Ecto repo module is bound at compile time: `config :seed_helper, repo: MyApp.Repo` (`config/config.exs`).
- Raw SQL paths: strict `PostgrexTypes` rejects string uuids — cast properly.
- Seed ordering matters for consumers' Liquibase/Ecto flows — document any new seed stages.
