import Config

# Configures the endpoint
config :chatter, ChatterWeb.Endpoint,
  url: [host: System.get_env("PHX_HOST")],
  render_errors: [view: ChatterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Chatter.PubSub,
  live_view: [signing_salt: System.get_env("SIGNING_SALT")]

# Configures the mailer (probably going to be removed)
config :chatter, Chatter.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure Keycloak
config :keycloak,
  realm: "csh",
  site: "https://sso.csh.rit.edu",
  client_id: "chatter",
  client_secret: System.get_env("KEYCLOAK_SECRET"),
  redirect_uri: System.get_env("PUBLISHED_SCHEME") <> "://" <> System.get_env("PHX_HOST") <> "/oidc/callback"

import_config "#{config_env()}.exs"
