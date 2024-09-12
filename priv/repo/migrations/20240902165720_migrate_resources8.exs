defmodule Animina.Repo.Migrations.MigrateResources8 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:photo_flag_tags, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :description, :text

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "photo_flag_tags_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :photo_id,
          references(:photos,
            column: :id,
            name: "photo_flag_tags_photo_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          )

      add :flag_id,
          references(:traits_flags,
            column: :id,
            name: "photo_flag_tags_flag_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          )
    end
  end

  def down do
    drop constraint(:photo_flag_tags, "photo_flag_tags_user_id_fkey")

    drop constraint(:photo_flag_tags, "photo_flag_tags_photo_id_fkey")

    drop constraint(:photo_flag_tags, "photo_flag_tags_flag_id_fkey")

    drop table(:photo_flag_tags)
  end
end