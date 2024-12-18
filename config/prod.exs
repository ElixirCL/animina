import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :animina, AniminaWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  http: [ip: {0, 0, 0, 0}, port: System.get_env("PORT") || 4005],
  server: true

config :animina, Animina.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "localhost",
  port: 25,
  domain: "animina.de",
  ssl: false,
  tls: :never,
  auth: :never,
  retries: 2

config :swoosh,
  api_client: false,
  adapter: Swoosh.Adapters.SMTP,
  relay: "localhost",
  port: 25,
  domain: "animina.de"

# Do not print debug messages in production
config :logger, level: :info

# Configures the llama version
config :animina, :llm_version, "llama3.1:8b"

# configures the number of days behind we check when showing users on the sidebar for potential partners

config :animina, :number_of_days_to_filter_registered_users, 600

config :animina, :environment, :prod

config :animina, :uploads_directory, "/uploads"

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
