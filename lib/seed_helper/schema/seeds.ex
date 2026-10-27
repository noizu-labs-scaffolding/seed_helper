defmodule SeedHelper.Schema.Seeds do
  @moduledoc """
  〚📦:2ea23f18-a7e2-5f96-8351-4d4758b6a960〛 SeedHelper.Schema.Seeds :: Ecto schema for seed_helper_seeds composite PK (seed, version).
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "seed_helper_seeds" do
    field :seed, :string, primary_key: true
    field :version, :string, primary_key: true
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:seed, :version])
    |> validate_required([:seed, :version])
  end
end
