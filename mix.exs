defmodule SeedHelper.MixProject do
  use Mix.Project

  def project do
    [
      app: :seed_helper,
      name: "Migration SeedHelper",
      version: "0.1.1",
      package: package(),
      description: description(),
      elixir: "~> 1.10",
      deps: deps(),
      docs: docs()
    ]
  end

  defp docs() do
    [
      main: "readme.md",
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end

  defp description() do
    "Migration Seed Helper Utility: provides tracked seed blocks, required_seed blocks that queue until seed prerequisites are met, and if_env blocks that only run in specific environments."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{
        project: "https://github.com/noizu-labs-scaffolding/seed_helper",
        noizu_labs: "https://github.com/noizu-labs",
        noizu_labs_ml: "https://github.com/noizu-labs-ml",
        noizu_labs_scaffolding: "https://github.com/noizu-labs-scaffolding",
        developer: "https://github.com/noizu"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.6"},
      {:elixir_uuid, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
