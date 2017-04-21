# PlugEtsCache

A simple http response caching system based on [Plug](https://github.com/elixir-lang/plug) and [ETS](http://erlang.org/doc/man/ets.html). It easily integrates in every application that uses Plug, including a Phoenix dedicated adapter.

The main use case is when the contents of your web pages don't change in real time and are served to a multitude of visitors. Even if your server response times are in order of few tens of milliseconds, caching pages into ETS (hence into RAM) would shrink times to microseconds.

Cache duration can be configured with a combination of a `ttl` value and `ttl_check`. Check [con_cache](https://github.com/sasa1977/con_cache) documentation for more details on this, PlugEtsCache uses it to read/write to ETS.

## Installation

The package is available in [Hex](https://hex.pm/packages/plug_ets_cache), follow these steps to install:

1. Add `plug_ets_cache` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    # Get from hex
    [{:plug_ets_cache, "~> 0.1.0"}]
    # Or use the latest from master
    [{:plug_ets_cache, github: "andreapavoni/plug_ets_cache"}]
  end
  ```

2. Ensure `plug_ets_cache` is started before your application:

  ```elixir
  def application do
    [applications: [:plug_ets_cache]]
  end
  ```

## Usage
These are the common steps to setup `PlugEtsCache`:

1. Set configuration in `config/config.exs` (the following values are defaults):

  ```elixir
  config :plug_ets_cache,
    db_name: :ets_cache,
    ttl_check: 60,
    ttl: 300
  ```

2. Add `PlugEtsCache.Plug` to your router/plug:

  ```elixir
  plug PlugEtsCache.Plug
  ```

Now follow specific instructions below for your use case.

### With Phoenix
Because Phoenix has a more complex lifecycle when it comes to send a response, it
has a special module for this.

1. Add ` use PlugEtsCache.Phoenix`
2. Call `cache_response` *after you've sent a response*:

  ```elixir
  defmodule MyApp.SomeController do
    use MyApp.Web, :controller
    use PlugEtsCache.Phoenix

    # ...

    def index(conn, params) do
      # ...
      conn
      |> render "index.html"
      |> cache_response
    end

    # ...
  end
  ```

### With plain Plug
Supposing a very simple Plug module:
1. Import  `PlugEtsCache.Response.cache_response/1` inside your module
2. Call `cache_response` *after you've sent a response*:

```elixir
defmodule FooController do
  use Plug.Router
  import PlugEtsCache.Response, only: [cache_response: 1]

  plug :match
  plug :dispatch

  get "/" do
    Plug.Conn.fetch_query_params(conn)
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello cache")
    |> cache_response
  end
end
```

## Documentation
The docs can be found at [https://hexdocs.pm/plug_ets_cache](https://hexdocs.pm/plug_ets_cache).

## TODO

* add more detailed docs
* configure `ttl` on specific cached responses

## Contributing

Everyone is welcome to contribute to PlugEtsCache and help tackling existing issues!

Use the [issue tracker](https://github.com/andreapavoni/plug_ets_cache/issues) for bug reports or feature requests.

Please, do your best to follow the [Elixir's Code of Conduct](https://github.com/elixir-lang/elixir/blob/master/CODE_OF_CONDUCT.md).

## License

This source code is released under MIT License. Check [LICENSE](https://github.com/andreapavoni/plug_ets_cache/blob/master/LICENSE) file for more information.
