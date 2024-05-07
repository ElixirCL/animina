defmodule Animina.Repo.Migrations.MigrateResources14 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :last_registration_page_visited, :text, default: "/my/potential-partner"
    end
  end

  def down do
    alter table(:users) do
      modify :last_registration_page_visited, :text, default: nil
    end
  end
end