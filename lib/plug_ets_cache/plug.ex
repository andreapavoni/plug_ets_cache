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
  import Plug.Conn


  def init(opts) when is_list(opts) do
    opts
  end

  def init(_), do: []

  def call(conn, opts) do
    case Store.get(conn, opts) do
      nil ->
        conn

      result ->
        conn
        |> put_resp_content_type(result.type, nil)
        |> send_resp(200, result.value)
        |> halt
    end
  end
end
