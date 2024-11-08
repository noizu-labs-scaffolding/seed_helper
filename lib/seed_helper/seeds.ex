defmodule SeedHelper.Seeds do
  @repo Application.compile_env!(:seed_helper, :repo)
  alias SeedHelper.Schema.Seeds

  @doc """
  Check if {seed, version} has been executed
  """
  def executed?({seed,version}) do
    IO.inspect(seed, label: "SEED")
    IO.inspect(version, label: "version")
    seed = String.trim(seed)
    version = String.trim(version)

    case apply(@repo, :get_by, [Seeds, [seed: seed, version: version]]) do
      %Seeds{} -> true
      nil -> false
    end
  end

  @doc """
  Mark {seed, version} as executed
  """
  def mark_executed({seed,version}) do
    seed = String.trim(seed)
    version = String.trim(version)
    apply(@repo, :insert!, [%Seeds{seed: seed, version: version}, [on_conflict: :nothing]])
  end
end
