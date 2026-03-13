# Project Layout

```
seed_helper/
├── lib/
│   ├── seed_helper.ex              # Public API — macros: seed, requires_seed, if_env
│   └── seed_helper/
│       ├── handles.ex              # Named handle storage with ETS cache
│       ├── migration.ex            # Ecto migration for seed_helper tables
│       ├── seeds.ex                # Seed execution tracking (executed?/mark_executed)
│       ├── session.ex              # Session lifecycle and dependency resolution
│       └── schema/
│           ├── handles.ex          # Ecto schema for seed_helper_handles table
│           └── seeds.ex            # Ecto schema for seed_helper_seeds table
├── config/
│   └── config.exs                  # App config — set :seed_helper, repo: YourApp.Repo
├── docs/                           # Project documentation
│   ├── PROJ-ARCH.md                #   Architecture overview
│   ├── PROJ-ARCH.summary.md        #   Architecture quick reference
│   ├── PROJ-LAYOUT.md              #   This file — project structure map
│   └── PROJ-LAYOUT.summary.md      #   Layout quick reference
├── test/
│   ├── seed_helper_test.exs        # Tests
│   └── test_helper.exs             # Test bootstrap
├── .formatter.exs                  # Mix format configuration
├── .tool-versions                  # asdf — Erlang 27, Elixir 1.17, Node 22
├── mix.exs                         # Project definition and Hex package config
├── CHANGELOG.md                    # Release history
├── LICENSE                         # MIT
└── README.md                       # Usage guide and documentation
```

## Key Files Requiring Setup

| File | Action |
|------|--------|
| `config/config.exs` | Set `:seed_helper, repo:` to your app's Ecto Repo module |
