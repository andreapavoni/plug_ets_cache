if Code.ensure_loaded?(Phoenix.Controller) do
  defmodule FakeController do
    use Phoenix.Controller
    use PlugEtsCache.Phoenix

    plug(:put_layout, false)

    def index(conn, _params) do
      render(conn, "index.txt", %{value: "cache"})
      |> cache_response
    end

    def index_with_ttl(conn, _params) do
      render(conn, "index.txt", %{value: "cache"})
      |> cache_response(:timer.seconds(30))
    end

    def index_with_opts(conn, _params) do
      render(conn, "index.txt", %{value: "cache_opts"})
      |> cache_response([ttl: :timer.seconds(30), cache_key: fn conn -> conn.request_path end])
    end
  end

  defmodule(FakeView, do: use(Phoenix.View, root: "test/support"))

  defmodule PlugEtsCache.PhoenixTest do
    use ExUnit.Case, async: true
    use Plug.Test

    def action(controller, verb, action, headers \\ []) do
      conn = conn(verb, "/", headers) |> Plug.Conn.fetch_query_params()
      controller.call(conn, controller.init(action))
    end

    test "caches the controller response" do
      conn = action(FakeController, :get, :index, "content-type": "text/plain")
      cached_resp = PlugEtsCache.Store.get(conn)

      assert conn.resp_body == "Hello cache\n"
      assert cached_resp.value == conn.resp_body
      assert cached_resp.type == "text/plain; charset=utf-8"
    end

    test "caches the controller response with ttl" do
      conn = action(FakeController, :get, :index_with_ttl, "content-type": "text/plain")
      cached_resp = PlugEtsCache.Store.get(conn)

      assert conn.resp_body == "Hello cache\n"
      assert cached_resp.value == conn.resp_body
      assert cached_resp.type == "text/plain; charset=utf-8"
    end

    test "caches the controller response with specified options" do
      conn = action(FakeController, :get, :index_with_opts, "content-type": "text/plain")
      cached_resp = PlugEtsCache.Store.get(conn, [cache_key: fn conn -> conn.request_path end])

      assert conn.resp_body == "Hello cache_opts\n"
      assert cached_resp.value == conn.resp_body
      assert cached_resp.type == "text/plain; charset=utf-8"
    end
  end
end
