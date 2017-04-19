defmodule PhoenixEtsCache.Store do
  def get(%Plug.Conn{} = conn) do
    ConCache.get(:movie_cache, key(conn))
  end

  def set(%Plug.Conn{} = conn, type, value) when is_binary(value) do
    ConCache.put(:movie_cache, key(conn), %{type: type, value: value})
  end

  defp key(conn) do
    "#{conn.request_path}#{conn.query_string}"
  end
end
