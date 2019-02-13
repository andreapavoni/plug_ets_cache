defmodule PlugEtsCache.Store do
  @moduledoc """
  This module contains functions to get/set cached responses.

  Example usage:
      conn = %Plug.Conn{request_path: "/test", query_string: ""}

      PlugEtsCache.Store.set(conn, "text/plain", "Hello cache")

      PlugEtsCache.Store.get(conn) # %{type: "text/plain", value: "Hello cache"}

  It's usually not needed to use these functions directly because the response
  caching happens in `PlugEtsCache.Response` and `PlugEtsCache.Plug`.
  """

  @doc """
  Retrieves eventual cached content based on `conn` params.
  """
  def get(%Plug.Conn{} = conn, opts \\ []) do
    cache_key_fn = Keyword.get(opts, :cache_key, &key/1)
    ConCache.get(db_name(), cache_key_fn.(conn))
  end

  @doc """
  Stores `conn` response data in the cache.
  """
  def set(%Plug.Conn{} = conn, type, value) when is_binary(value) do
    set(conn, type, value, [])
  end

  @doc """
  Stores `conn` response data in the cache with specified ttl.
  """
  def set(%Plug.Conn{} = conn, type, value, ttl) when is_binary(value) and (is_number(ttl) or is_atom(ttl)) do
    set(conn, type, value, ttl: ttl)
  end

  @doc """
  Stores `conn` response data in the cache with the specified options.

  Recognized options:

  - `ttl`, the ttl of the item (i.e `[ttl: 1_000]`)
  - `cache_key`, a function taking one argument (the conn) that returns the key for to use for the item in the cache.
  """
  def set(%Plug.Conn{} = conn, type, value, opts) when is_list(opts) do
    ttl = Keyword.get(opts, :ttl)
    cache_key_fn = Keyword.get(opts, :cache_key, &key/1)

    item = case ttl do
      nil -> %{type: type, value: value}
      _else -> %ConCache.Item{value: %{type: type, value: value}, ttl: ttl}
    end

    ConCache.put(db_name(), cache_key_fn.(conn), item)
    conn
  end

  defp key(conn) do
    "#{conn.request_path}#{conn.query_string}"
  end

  defp db_name do
    Application.get_env(:plug_ets_cache, :db_name, :ets_cache)
  end
end
