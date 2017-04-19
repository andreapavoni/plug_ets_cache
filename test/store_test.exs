defmodule PhoenixEtsCache.StoreTest do
  use ExUnit.Case, async: true

  test "sets and gets values from cache" do
    conn = %Plug.Conn{request_path: "/test", query_string: ""}

    PhoenixEtsCache.Store.set(conn, "text/plain", "Hello cache")
    cache = PhoenixEtsCache.Store.get(conn)

    assert cache.value == "Hello cache"
    assert cache.type == "text/plain"
  end
end
