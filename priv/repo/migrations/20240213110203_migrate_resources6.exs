defmodule Animina.Repo.Migrations.MigrateResources6 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:users) do
      add :search_range, :bigint
    end

    alter table(:credits) do
      modify :user_id, :uuid, null: false
      modify :subject, :text, null: false
      modify :points, :bigint, null: false
    end
  end

  def down do
    alter table(:credits) do
      modify :points, :bigint, null: true
      modify :subject, :text, null: true
      modify :user_id, :uuid, null: true
    end

    alter table(:users) do
      remove :search_range
    end
  end
end