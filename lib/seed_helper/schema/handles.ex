defmodule SeedHelper.Schema.Handles do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "seed_helper_handles" do
    field :handle, :string, primary_key: true
    field :value, :string
    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:handle, :value])
    |> validate_required([:handle, :value])
  end
end
