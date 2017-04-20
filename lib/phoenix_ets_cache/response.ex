defmodule PhoenixEtsCache.Response do
  def cache_response(%Plug.Conn{resp_body: nil, state: :unset} = conn), do: conn
  def cache_response(%Plug.Conn{resp_body: body, state: :sent, status: status} = conn) when status in (200..299) do
    content_type = conn
    |> Plug.Conn.get_resp_header("content-type")
    |> hd

    PhoenixEtsCache.Store.set(conn, content_type, body)
  end
end
