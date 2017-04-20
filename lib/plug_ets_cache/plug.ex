defmodule PlugEtsCache.Plug do
  @moduledoc """
  A Plug used to send cached responses if any.

  Example usage:
      defmodule MyApp.Router do
        # use/import modules depending on your framework/lib
        plug PlugEtsCache.Plug
      end
  """

  alias PlugEtsCache.Store
  use Plug.Builder

  plug :lookup

  def lookup(conn, _opts) do
    case Store.get(conn) do
      nil    -> conn
      result ->
        conn
        |> put_resp_content_type(result.type)
        |> send_resp(200, result.value)
        |> halt
    end
  end
end
