defmodule Animina.Repo.Migrations.MigrateResources18 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:users) do
      add :confirmation_pin, :text
      add :confirmation_pin_attempts, :bigint, default: 0
    end
  end

  def down do
    alter table(:users) do
      remove :confirmation_pin_attempts
      remove :confirmation_pin
    end
  end
end