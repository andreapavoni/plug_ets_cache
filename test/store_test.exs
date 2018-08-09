defmodule PlugEtsCache.StoreTest do
  use ExUnit.Case, async: true

  test "sets and gets values from cache" do
    conn = %Plug.Conn{request_path: "/test", query_string: ""}

    PlugEtsCache.Store.set(conn, "text/plain", "Hello cache")
    cache = PlugEtsCache.Store.get(conn)

    assert cache.value == "Hello cache"
    assert cache.type == "text/plain"
  end

  test "sets and gets values from cache with ttl provided" do
    conn = %Plug.Conn{request_path: "/test", query_string: ""}

    PlugEtsCache.Store.set(conn, "text/plain", "Hello cache", 1000)
    cache = PlugEtsCache.Store.get(conn)

    assert cache.value == "Hello cache"
    assert cache.type == "text/plain"
  end
end
