import Config

# disable cache in dev
config :chatter, ChatterWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# Watch static and templates for browser reloading.
config :chatter, ChatterWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/chatter_web/(live|views)/.*(ex)$",
      ~r"lib/chatter_web/templates/.*(eex)$"
    ]
  ]

# Configure Keycloak for Dev
config :keycloak,
  realm: "csh",
  site: "https://sso.csh.rit.edu",
  client_id: "chatter",
  client_secret: System.get_env("KEYCLOAK_SECRET"),
  redirect_uri: "http://localhost:4000/oidc/callback"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
