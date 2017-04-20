defmodule PlugEtsCache.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_ets_cache,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {PlugEtsCache, []}]
  end

  defp deps do
    [
      {:plug, "~> 1.3.5"},
      {:con_cache, "~> 0.12.0"}
    ]
  end
end
