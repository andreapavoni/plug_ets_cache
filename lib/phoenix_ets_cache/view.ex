defmodule PhoenixEtsCache.View do
  defmacro __using__(layout) do
    quote do
      import Phoenix.View, only: [render_to_string: 3]

      def cache_and_render(conn, template, content_type, assigns \\ %{}) do
        conn
        |> cache_response(template, content_type, assigns)
        |> render(template, assigns)
      end

      defp cache_response(conn, template, content_type, assigns \\ %{}) do
        assigns = Map.merge(assigns, %{conn: conn, layout: unquote(layout)})
        response = render_to_string(view_module(conn), template, assigns)

        PhoenixEtsCache.Store.set(conn, content_type, response)
        conn
      end
    end
  end
end
