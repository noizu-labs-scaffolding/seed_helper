SeedHelper is an Elixir library for idempotent, dependency-aware database seeding in Ecto apps.

**Components**: Public macro API (seed, requires_seed, if_env) → Session Agent (dependency resolution) → Seeds module (DB-backed idempotency) → Handles module (ETS-cached named values) → Migration (table setup) → Ecto Schemas.

**Flow**: begin_session starts Agent + ETS → seed blocks check DB and execute once → requires_seed queues until dependencies resolve → end_session reports unresolved deps.

**Stack**: Elixir, Ecto SQL, ETS, Agent, elixir_uuid. Published on Hex as :seed_helper.
