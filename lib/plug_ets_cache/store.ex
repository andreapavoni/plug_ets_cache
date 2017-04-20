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
  def get(%Plug.Conn{} = conn) do
    ConCache.get(db_name(), key(conn))
  end

  @doc """
  Stores `conn` response data in the cache.
  """
  def set(%Plug.Conn{} = conn, type, value) when is_binary(value) do
    ConCache.put(db_name(), key(conn), %{type: type, value: value})
    conn
  end

  defp key(conn) do
    "#{conn.request_path}#{conn.query_string}"
  end

  defp db_name do
    Application.get_env(:plug_ets_cache, :db_name, :ets_cache)
  end
end
