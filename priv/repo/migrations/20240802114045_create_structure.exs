defmodule Animina.Repo.Migrations.CreateStructure do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:visit_log_entries, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :duration, :bigint, null: false
      add :bookmark_id, :uuid, null: false
      add :user_id, :uuid, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create index(:visit_log_entries, [:user_id, :bookmark_id])

    create table(:users, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :text, null: false
      add :username, :citext, null: false
      add :name, :text, null: false
      add :birthday, :date, null: false
      add :zip_code, :text
      add :state, :text, null: false, default: "normal"
      add :gender, :text, null: false
      add :height, :bigint, null: false
      add :mobile_phone, :text, null: false
      add :minimum_partner_height, :bigint
      add :maximum_partner_height, :bigint
      add :minimum_partner_age, :bigint
      add :maximum_partner_age, :bigint
      add :partner_gender, :text
      add :search_range, :bigint
      add :language, :text
      add :legal_terms_accepted, :boolean, default: false
      add :preapproved_communication_only, :boolean, default: false
      add :streak, :bigint, default: 0
      add :last_registration_page_visited, :text, default: "/my/potential-partner"
      add :occupation, :text
      add :is_private, :boolean, default: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :confirmed_at, :utc_datetime_usec
    end

    create unique_index(:users, [:email], name: "users_unique_email_index")

    create unique_index(:users, [:mobile_phone], name: "users_unique_mobile_phone_index")

    create unique_index(:users, [:username], name: "users_unique_username_index")

    create table(:user_roles, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "user_roles_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :role_id, :uuid, null: false
    end

    create table(:user_flags, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :flag_id, :uuid, null: false

      add :user_id,
          references(:users,
            column: :id,
            name: "user_flags_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :position, :bigint, null: false
      add :color, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create index(:user_flags, [:color, :user_id])

    create index(:user_flags, [:flag_id, :user_id])

    create index(:user_flags, [:flag_id])

    create index(:user_flags, [:user_id])

    create table(:traits_flags, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :name, :citext, null: false
      add :emoji, :text
      add :category_id, :uuid
    end

    create table(:traits_flag_translations, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :language, :text, null: false
      add :name, :citext, null: false
      add :hashtag, :citext, null: false

      add :flag_id,
          references(:traits_flags,
            column: :id,
            name: "traits_flag_translations_flag_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create unique_index(:traits_flag_translations, [:hashtag, :language],
             name: "traits_flag_translations_hashtag_index"
           )

    create unique_index(:traits_flag_translations, [:name, :language, :flag_id],
             name: "traits_flag_translations_unique_name_index"
           )

    create table(:traits_category_translations, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :language, :text, null: false
      add :name, :citext, null: false
      add :category_id, :uuid
    end

    create table(:traits_categories, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:traits_flags) do
      modify :category_id,
             references(:traits_categories,
               column: :id,
               name: "traits_flags_category_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    create unique_index(:traits_flags, [:name, :category_id],
             name: "traits_flags_unique_name_index"
           )

    alter table(:traits_category_translations) do
      modify :category_id,
             references(:traits_categories,
               column: :id,
               name: "traits_category_translations_category_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:traits_categories) do
      add :name, :citext, null: false
    end

    create unique_index(:traits_categories, [:name], name: "traits_categories_unique_name_index")

    create table(:tokens, primary_key: false) do
      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :extra_data, :map
      add :purpose, :text, null: false
      add :expires_at, :utc_datetime, null: false
      add :subject, :text, null: false
      add :jti, :text, null: false, primary_key: true
    end

    create table(:stories, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :content, :text
      add :position, :bigint, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "stories_user_id_fkey",
            type: :uuid,
            prefix: "public"
          )

      add :headline_id, :uuid
    end

    create table(:roles, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:user_roles) do
      modify :role_id,
             references(:roles,
               column: :id,
               name: "user_roles_role_id_fkey",
               type: :uuid,
               prefix: "public",
               on_delete: :delete_all
             )
    end

    alter table(:roles) do
      add :name, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create table(:reports, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :state, :text, null: false
      add :accused_user_state, :text, null: false
      add :description, :text, null: false
      add :internal_memo, :text

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :accused_id,
          references(:users,
            column: :id,
            name: "reports_accused_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false

      add :accuser_id,
          references(:users,
            column: :id,
            name: "reports_accuser_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false

      add :admin_id,
          references(:users,
            column: :id,
            name: "reports_admin_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create table(:reactions, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :name, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :sender_id,
          references(:users,
            column: :id,
            name: "reactions_sender_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :receiver_id,
          references(:users,
            column: :id,
            name: "reactions_receiver_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false
    end

    create unique_index(:reactions, [:sender_id, :receiver_id, :name],
             name: "reactions_unique_reaction_index"
           )

    create table(:potential_partners, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :is_active, :boolean, null: false, default: true
      add :position, :bigserial, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "potential_partners_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :potential_partner_id,
          references(:users,
            column: :id,
            name: "potential_partners_potential_partner_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false
    end

    create index(:potential_partners, [:user_id, :potential_partner_id])

    create index(:potential_partners, [:user_id])

    create unique_index(:potential_partners, [:user_id, :potential_partner_id],
             name: "potential_partners_unique_potential_partner_index"
           )

    create table(:posts, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :content, :text, null: false
      add :slug, :text, null: false
      add :title, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "posts_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          )
    end

    create index(:posts, [:user_id])

    create table(:photos, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :filename, :text, null: false
      add :original_filename, :text, null: false
      add :mime, :text, null: false
      add :size, :bigint, null: false
      add :ext, :text, null: false
      add :dimensions, :map
      add :error, :text
      add :error_state, :text
      add :state, :text, null: false, default: "pending_review"

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "photos_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :story_id,
          references(:stories,
            column: :id,
            name: "photos_story_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create table(:optimized_photos, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :image_url, :text, null: false
      add :type, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "optimized_photos_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :photo_id,
          references(:photos,
            column: :id,
            name: "optimized_photos_photo_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          )
    end

    create table(:messages, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :content, :text, null: false
      add :read_at, :utc_datetime_usec

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :sender_id,
          references(:users,
            column: :id,
            name: "messages_sender_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :receiver_id,
          references(:users,
            column: :id,
            name: "messages_receiver_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false
    end

    create table(:headlines, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:stories) do
      modify :headline_id,
             references(:headlines,
               column: :id,
               name: "stories_headline_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    create unique_index(:stories, [:position, :user_id], name: "stories_unique_position_index")

    alter table(:headlines) do
      add :subject, :text, null: false
      add :position, :bigint, null: false
      add :is_active, :boolean, default: true
    end

    create unique_index(:headlines, [:position], name: "headlines_unique_position_index")

    create unique_index(:headlines, [:subject], name: "headlines_unique_subject_index")

    create table(:geo_data_cities, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :name, :citext, null: false
      add :zip_code, :text, null: false
      add :county, :citext, null: false
      add :federal_state, :citext, null: false
      add :lat, :float, null: false
      add :lon, :float, null: false
    end

    create unique_index(:geo_data_cities, [:zip_code],
             name: "geo_data_cities_unique_zip_code_index"
           )

    create table(:credits, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :points, :bigint, null: false
      add :subject, :text, null: false

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :user_id,
          references(:users,
            column: :id,
            name: "credits_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :donor_id,
          references(:users,
            column: :id,
            name: "credits_donor_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create table(:bookmarks, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
    end

    alter table(:visit_log_entries) do
      modify :bookmark_id,
             references(:bookmarks,
               column: :id,
               name: "visit_log_entries_bookmark_id_fkey",
               type: :uuid,
               prefix: "public",
               on_delete: :delete_all
             )

      modify :user_id,
             references(:users,
               column: :id,
               name: "visit_log_entries_user_id_fkey",
               type: :uuid,
               prefix: "public",
               on_delete: :delete_all
             )
    end

    alter table(:bookmarks) do
      add :reason, :text, null: false

      add :owner_id,
          references(:users,
            column: :id,
            name: "bookmarks_owner_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :user_id,
          references(:users,
            column: :id,
            name: "bookmarks_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false

      add :last_visit_at, :utc_datetime

      add :created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create index(:bookmarks, [:owner_id, :reason])

    create index(:bookmarks, [:owner_id, :user_id])

    create index(:bookmarks, [:user_id])

    create index(:bookmarks, [:reason])

    create index(:bookmarks, [:owner_id])

    create unique_index(:bookmarks, [:user_id, :owner_id, :reason],
             name: "bookmarks_unique_bookmark_index"
           )

    create table(:bad_passwords, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true
      add :value, :citext, null: false
    end

    create unique_index(:bad_passwords, [:value], name: "bad_passwords_value_index")
  end

  def down do
    drop_if_exists unique_index(:bad_passwords, [:value], name: "bad_passwords_value_index")

    drop table(:bad_passwords)

    drop_if_exists unique_index(:bookmarks, [:user_id, :owner_id, :reason],
                     name: "bookmarks_unique_bookmark_index"
                   )

    drop constraint(:bookmarks, "bookmarks_owner_id_fkey")

    drop constraint(:bookmarks, "bookmarks_user_id_fkey")

    drop_if_exists index(:bookmarks, [:owner_id])

    drop_if_exists index(:bookmarks, [:reason])

    drop_if_exists index(:bookmarks, [:user_id])

    drop_if_exists index(:bookmarks, [:owner_id, :user_id])

    drop_if_exists index(:bookmarks, [:owner_id, :reason])

    alter table(:bookmarks) do
      remove :updated_at
      remove :created_at
      remove :last_visit_at
      remove :user_id
      remove :owner_id
      remove :reason
    end

    drop constraint(:visit_log_entries, "visit_log_entries_bookmark_id_fkey")

    drop constraint(:visit_log_entries, "visit_log_entries_user_id_fkey")

    alter table(:visit_log_entries) do
      modify :user_id, :uuid
      modify :bookmark_id, :uuid
    end

    drop table(:bookmarks)

    drop constraint(:credits, "credits_user_id_fkey")

    drop constraint(:credits, "credits_donor_id_fkey")

    drop table(:credits)

    drop_if_exists unique_index(:geo_data_cities, [:zip_code],
                     name: "geo_data_cities_unique_zip_code_index"
                   )

    drop table(:geo_data_cities)

    drop_if_exists unique_index(:headlines, [:subject], name: "headlines_unique_subject_index")

    drop_if_exists unique_index(:headlines, [:position], name: "headlines_unique_position_index")

    alter table(:headlines) do
      remove :is_active
      remove :position
      remove :subject
    end

    drop_if_exists unique_index(:stories, [:position, :user_id],
                     name: "stories_unique_position_index"
                   )

    drop constraint(:stories, "stories_headline_id_fkey")

    alter table(:stories) do
      modify :headline_id, :uuid
    end

    drop table(:headlines)

    drop constraint(:messages, "messages_sender_id_fkey")

    drop constraint(:messages, "messages_receiver_id_fkey")

    drop table(:messages)

    drop constraint(:optimized_photos, "optimized_photos_user_id_fkey")

    drop constraint(:optimized_photos, "optimized_photos_photo_id_fkey")

    drop table(:optimized_photos)

    drop constraint(:photos, "photos_user_id_fkey")

    drop constraint(:photos, "photos_story_id_fkey")

    drop table(:photos)

    drop constraint(:posts, "posts_user_id_fkey")

    drop_if_exists index(:posts, [:user_id])

    drop table(:posts)

    drop_if_exists unique_index(:potential_partners, [:user_id, :potential_partner_id],
                     name: "potential_partners_unique_potential_partner_index"
                   )

    drop constraint(:potential_partners, "potential_partners_user_id_fkey")

    drop constraint(:potential_partners, "potential_partners_potential_partner_id_fkey")

    drop_if_exists index(:potential_partners, [:user_id])

    drop_if_exists index(:potential_partners, [:user_id, :potential_partner_id])

    drop table(:potential_partners)

    drop_if_exists unique_index(:reactions, [:sender_id, :receiver_id, :name],
                     name: "reactions_unique_reaction_index"
                   )

    drop constraint(:reactions, "reactions_sender_id_fkey")

    drop constraint(:reactions, "reactions_receiver_id_fkey")

    drop table(:reactions)

    drop constraint(:reports, "reports_accused_id_fkey")

    drop constraint(:reports, "reports_accuser_id_fkey")

    drop constraint(:reports, "reports_admin_id_fkey")

    drop table(:reports)

    alter table(:roles) do
      remove :updated_at
      remove :created_at
      remove :name
    end

    drop constraint(:user_roles, "user_roles_role_id_fkey")

    alter table(:user_roles) do
      modify :role_id, :uuid
    end

    drop table(:roles)

    drop constraint(:stories, "stories_user_id_fkey")

    drop table(:stories)

    drop table(:tokens)

    drop_if_exists unique_index(:traits_categories, [:name],
                     name: "traits_categories_unique_name_index"
                   )

    alter table(:traits_categories) do
      remove :name
    end

    drop constraint(
           :traits_category_translations,
           "traits_category_translations_category_id_fkey"
         )

    alter table(:traits_category_translations) do
      modify :category_id, :uuid
    end

    drop_if_exists unique_index(:traits_flags, [:name, :category_id],
                     name: "traits_flags_unique_name_index"
                   )

    drop constraint(:traits_flags, "traits_flags_category_id_fkey")

    alter table(:traits_flags) do
      modify :category_id, :uuid
    end

    drop table(:traits_categories)

    drop table(:traits_category_translations)

    drop_if_exists unique_index(:traits_flag_translations, [:name, :language, :flag_id],
                     name: "traits_flag_translations_unique_name_index"
                   )

    drop_if_exists unique_index(:traits_flag_translations, [:hashtag, :language],
                     name: "traits_flag_translations_hashtag_index"
                   )

    drop constraint(:traits_flag_translations, "traits_flag_translations_flag_id_fkey")

    drop table(:traits_flag_translations)

    drop table(:traits_flags)

    drop constraint(:user_flags, "user_flags_user_id_fkey")

    drop_if_exists index(:user_flags, [:user_id])

    drop_if_exists index(:user_flags, [:flag_id])

    drop_if_exists index(:user_flags, [:flag_id, :user_id])

    drop_if_exists index(:user_flags, [:color, :user_id])

    drop table(:user_flags)

    drop constraint(:user_roles, "user_roles_user_id_fkey")

    drop table(:user_roles)

    drop_if_exists unique_index(:users, [:username], name: "users_unique_username_index")

    drop_if_exists unique_index(:users, [:mobile_phone], name: "users_unique_mobile_phone_index")

    drop_if_exists unique_index(:users, [:email], name: "users_unique_email_index")

    drop table(:users)

    drop_if_exists index(:visit_log_entries, [:user_id, :bookmark_id])

    drop table(:visit_log_entries)
  end
end