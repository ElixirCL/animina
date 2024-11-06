defmodule Animina.Repo.Migrations.AddIndexesToResourcesUsedInFastUser do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create index(:users, [:zip_code])

    create index(:users, [:is_private])

    create index(:users, [:created_at])

    create index(:users, [:gender])

    create index(:users, [:state])

    create index(:users, [:registration_completed_at])

    create index(:user_roles, [:user_id])

    create index(:user_roles, [:role_id])

    create index(:traits_flags, [:category_id])

    create index(:stories, [:user_id])

    create index(:stories, [:headline_id])

    create index(:reactions, [:receiver_id])

    create index(:reactions, [:sender_id])

    create index(:photos, [:user_id])

    create index(:photos, [:story_id])

    create index(:photo_flags, [:flag_id])

    create index(:photo_flags, [:user_id])

    create index(:photo_flags, [:photo_id])

    create index(:optimized_photos, [:user_id])

    create index(:optimized_photos, [:photo_id])

    create index(:geo_data_cities, [:zip_code])

    create index(:credits, [:user_id])

    create index(:credits, [:donor_id])
  end

  def down do
    drop_if_exists index(:credits, [:donor_id])

    drop_if_exists index(:credits, [:user_id])

    drop_if_exists index(:geo_data_cities, [:zip_code])

    drop_if_exists index(:optimized_photos, [:photo_id])

    drop_if_exists index(:optimized_photos, [:user_id])

    drop_if_exists index(:photo_flags, [:photo_id])

    drop_if_exists index(:photo_flags, [:user_id])

    drop_if_exists index(:photo_flags, [:flag_id])

    drop_if_exists index(:photos, [:story_id])

    drop_if_exists index(:photos, [:user_id])

    drop_if_exists index(:reactions, [:sender_id])

    drop_if_exists index(:reactions, [:receiver_id])

    drop_if_exists index(:stories, [:headline_id])

    drop_if_exists index(:stories, [:user_id])

    drop_if_exists index(:traits_flags, [:category_id])

    drop_if_exists index(:user_roles, [:role_id])

    drop_if_exists index(:user_roles, [:user_id])

    drop_if_exists index(:users, [:registration_completed_at])

    drop_if_exists index(:users, [:state])

    drop_if_exists index(:users, [:gender])

    drop_if_exists index(:users, [:created_at])

    drop_if_exists index(:users, [:is_private])

    drop_if_exists index(:users, [:zip_code])
  end
end
