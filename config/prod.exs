import Config

# declare cache manifest (generated by `mix assets.deploy`)
config :chatter, ChatterWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Configure Keycloak for Prod
config :keycloak,
  realm: "csh",
  site: "https://sso.csh.rit.edu",
  client_id: "chatter",
  client_secret: System.get_env("KEYCLOAK_SECRET"),
  redirect_uri: "https://chatter.csh.rit.edu/oidc/callback"

# SSL note: ssl encryption is handled by OKD, not PHX
