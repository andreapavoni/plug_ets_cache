defmodule PlugEtsCache.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "replies with cached content if present" do
    request = %Plug.Conn{request_path: "/test", query_string: ""}
    PlugEtsCache.Store.set(request, "text/plain", "Hello cache")

    conn =
      conn(:get, "/test")
      |> PlugEtsCache.Plug.call(PlugEtsCache.Plug.init(nil))

    assert conn.resp_body == "Hello cache"
    assert {"content-type", "text/plain; charset=utf-8"} in conn.resp_headers
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "return conn if not present" do
    conn =
      conn(:get, "/test2")
      |> PlugEtsCache.Plug.call(PlugEtsCache.Plug.init(nil))

    assert conn.state == :unset
    assert conn.status == nil
    assert conn.resp_body == nil
    refute {"content-type", "text/plain; charset=utf-8"} in conn.resp_headers
  end
end
