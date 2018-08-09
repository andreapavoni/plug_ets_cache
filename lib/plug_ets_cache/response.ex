defmodule PlugEtsCache.Response do
  @moduledoc """
  This module contains the helper to cache a Plug response.

  Example usage:
      defmodule MyApp.SomeController do
        # use/import modules depending on your framework/lib

        import PlugEtsCache.Response, only: [cache_response: 1]

        def index(conn, _params) do
          render(conn, "index.txt", %{value: "cache"})
          |> cache_response
        end
      end
  """

  def cache_response(%Plug.Conn{state: :unset} = conn), do: conn

  def cache_response(%Plug.Conn{state: :sent} = conn), do: cache_response(conn, nil)

  def cache_response(%Plug.Conn{state: :unset} = conn, _ttl), do: conn

  def cache_response(%Plug.Conn{state: :sent, resp_body: body, status: status} = conn, ttl) when status in 200..299 do
    content_type =
      conn
      |> Plug.Conn.get_resp_header("content-type")
      |> hd

    PlugEtsCache.Store.set(conn, content_type, body, ttl)
  end
end
