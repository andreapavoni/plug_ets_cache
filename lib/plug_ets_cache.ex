defmodule PlugEtsCache do
  @moduledoc """
  Implements an ETS based cache storage for Plug based applications.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ConCache, [
        [
          name: app_env(:db_name, :ets_cache),
          ttl_check_interval: :timer.seconds(app_env(:ttl_check, 60)),
          global_ttl: :timer.seconds(app_env(:ttl, 300))
        ]
      ])
    ]

    opts = [strategy: :one_for_one, name: PlugEtsCache]
    Supervisor.start_link(children, opts)
  end

  defp app_env(key, default) do
    Application.get_env(:plug_ets_cache, key, default)
  end
end
