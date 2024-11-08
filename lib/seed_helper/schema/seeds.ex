defmodule SeedHelper.Schema.Seeds do
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
