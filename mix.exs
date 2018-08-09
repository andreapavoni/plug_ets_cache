defmodule PlugEtsCache.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_ets_cache,
      version: "0.2.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      # Docs
      name: "PlugEtsCache",
      source_url: "https://github.com/andreapavoni/plug_ets_cache",
      homepage_url: "https://github.com/andreapavoni/plug_ets_cache",
      docs: [
        main: "PlugEtsCache",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {PlugEtsCache, []}]
  end

  defp deps do
    [
      {:plug, "~> 1.3"},
      {:con_cache, "~> 0.12.1"},
      {:phoenix, "~> 1.2 or ~> 1.3", optional: true},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      name: :plug_ets_cache,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Andrea Pavoni"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/andreapavoni/plug_ets_cache"}
    ]
  end

  defp description do
    """
    A simple caching system based on Plug and ETS.
    """
  end
end
