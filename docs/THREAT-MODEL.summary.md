SeedHelper is a library: no ports, no HTTP, no credentials, no ingress. Attack surface = the seed script boundary (arbitrary Elixir runs inline), the database boundary (handle values deserialised), and the BEAM node (public named ETS cache).

**Trust boundaries**: operator/CI seed script → library (no sandbox); library → host Repo (host's full DB privileges); DB → process (`binary_to_term`); any VM process → `SeedHelper.Handles.Cache`.

**Register**: 0 mitigated · 0 partial · 6 open.

| ID | Severity | STRIDE | Issue | Status |
|----|----------|--------|-------|--------|
| T-001 | High | Tampering / Elevation | `binary_to_term/1` without `[:safe]` on stored handle values | Open |
| T-002 | Medium | Tampering | `:public, :named_table` ETS handle cache | Open |
| T-003 | Medium | Tampering / Repudiation | `mark_executed/1` writes ledger rows with no execution proof | Open |
| T-004 | Low | Info disclosure | `executed?/1` `IO.inspect`s seed name/version | Open |
| T-005 | Low | Tampering | `if_env/2` gates on ambient `Mix.env()` | Open |
| T-006 | Low | Denial of service | `value` column is unbounded `text` | Open |

**Residual risk accepted**: trusted operators and seed authors, trusted database, advisory (not attested) seed ledger, single-node single seeding run.
