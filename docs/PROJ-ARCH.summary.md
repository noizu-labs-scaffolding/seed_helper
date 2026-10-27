SeedHelper is an Elixir library for idempotent, dependency-aware database seeding in Ecto apps.

**Components**: Public API (macros `seed`/`requires_seed`/`if_env`, functions `set_handle`/`handle`/`begin_session`/`end_session`) → Session Agent (change queue, applied set) → Seeds module (DB idempotency) → Handles module (term-encoded values + ETS cache) → Migration (`up(1)`/`down(1)`) → Ecto Schemas.

**Flow**: `begin_session` creates the ETS table + Agent → `seed` checks the DB and runs once → `requires_seed` parks a closure until prerequisites apply → `mark_applied` releases newly unblocked closures → `end_session` stops the Agent and returns `:ok` or `{:error, {:unprocessed_changes, pending}}`.

**Binding**: the host Repo is `Application.compile_env!(:seed_helper, :repo)` — compile-time, not runtime. No supervision tree; only `extra_applications: [:logger]`.

**Stack**: Elixir (CI 1.17.3/OTP 27.1.2), Ecto SQL ~> 3.6, ETS, Agent, elixir_uuid. Published on Hex as `:seed_helper`.
