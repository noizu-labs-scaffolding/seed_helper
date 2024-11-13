defmodule SeedHelper.Migration do
  use Ecto.Migration

  def up(1) do
    create table(:seed_helper_seeds, primary_key: false) do
      add :seed, :string, primary_key: true
      add :version, :string, primary_key: true
      timestamps(type: :utc_datetime_usec)
    end

    create table(:seed_helper_handles, primary_key: false) do
      add :handle, :string, primary_key: true
      add :value, :text, null: false
      timestamps(type: :utc_datetime_usec)
    end
  end

  def down(1) do
    drop table(:seed_helper_handles)
    drop table(:seed_helper_seeds)
  end
end
