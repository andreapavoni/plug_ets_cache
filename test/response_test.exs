defmodule FooController do
  use Plug.Router
  import PlugEtsCache.Response, only: [cache_response: 1]

  plug(:match)
  plug(:dispatch)

  get "/" do
    Plug.Conn.fetch_query_params(conn)
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello cache")
    |> cache_response
  end
end

defmodule PlugEtsCache.ResponseTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "caches the controller response" do
    conn =
      conn(:get, "/", "content-type": "text/plain")
      |> Plug.Conn.fetch_query_params()
      |> FooController.call(FooController)

    cached_resp = PlugEtsCache.Store.get(conn)

    assert conn.resp_body == "Hello cache"
    assert cached_resp.value == conn.resp_body
    assert cached_resp.type == "text/plain; charset=utf-8"
  end
end
