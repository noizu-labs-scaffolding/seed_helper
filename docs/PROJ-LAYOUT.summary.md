```
seed_helper/
├── lib/
│   ├── seed_helper.ex
│   └── seed_helper/
│       ├── handles.ex
│       ├── migration.ex
│       ├── seeds.ex
│       ├── session.ex
│       └── schema/
│           ├── handles.ex
│           └── seeds.ex
├── config/
│   └── config.exs
├── docs/
│   ├── PROJ-ARCH.md
│   ├── PROJ-ARCH.summary.md
│   ├── PROJ-LAYOUT.md
│   ├── PROJ-LAYOUT.summary.md
│   ├── PROJ-SCHEMA.md
│   ├── PROJ-SCHEMA.summary.md
│   ├── THREAT-MODEL.md
│   └── THREAT-MODEL.summary.md
├── test/
│   ├── seed_helper_test.exs
│   └── test_helper.exs
├── .github/workflows/ci.yml
├── .meta/pointers.yaml
├── .formatter.exs
├── .tool-versions
├── AGENT.md
├── AGENTS.md
├── CLAUDE.md
├── mix.exs
├── CHANGELOG.md
├── LICENSE
└── README.md
```

Setup requires `config/config.exs` (`:seed_helper, repo:`), a host-app migration
calling `SeedHelper.Migration.up(1)`, and `begin_session()`/`end_session()` around
seed files.
