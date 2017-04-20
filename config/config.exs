# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :plug_ets_cache,
  db_name: :ets_cache,
  ttl_check: 60,
  ttl: 300
