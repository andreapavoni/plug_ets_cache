defmodule PhoenixEtsCache.Store do
  def get(%Plug.Conn{} = conn) do
    ConCache.get(db_name(), key(conn))
  end

  def set(%Plug.Conn{} = conn, type, value) when is_binary(value) do
    ConCache.put(db_name(), key(conn), %{type: type, value: value})
  end

  defp key(conn) do
    "#{conn.request_path}#{conn.query_string}"
  end

  defp db_name do
    Application.get_env(:phoenix_ets_cache, :db_name, :ets_cache)
  end
end
