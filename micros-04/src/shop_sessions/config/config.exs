# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :shop_sessions, :scopes,
  user: [
    default: true,
    module: ShopSessions.Accounts.Scope,
    assign_key: :current_scope,
    access_path: [:user, :id],
    schema_key: :user_id,
    schema_type: :id,
    schema_table: :users,
    test_data_fixture: ShopSessions.AccountsFixtures,
    test_setup_helper: :register_and_log_in_user
  ]

config :shop_sessions,
  ecto_repos: [ShopSessions.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :shop_sessions, ShopSessionsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ShopSessionsWeb.ErrorHTML, json: ShopSessionsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ShopSessions.PubSub,
  live_view: [signing_salt: "Mib86zSv"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :shop_sessions, ShopSessions.Mailer, adapter: Swoosh.Adapters.Local

# Nebulex Redis Cluster cache - uses Docker service names
# Override in runtime.exs for different environments
config :shop_sessions, ShopSessions.Cache,
  mode: :redis_cluster,
  redis_cluster: [
    configuration_endpoints: [
      endpoint1_conn_opts: [host: "redis-1", port: 6379],
      endpoint2_conn_opts: [host: "redis-2", port: 6379],
      endpoint3_conn_opts: [host: "redis-3", port: 6379]
    ]
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  shop_sessions: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.12",
  shop_sessions: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
