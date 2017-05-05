if Code.ensure_loaded?(Phoenix.Controller) do
  defmodule PlugEtsCache.Phoenix do
    defmacro __using__(_) do
      quote do
        import Phoenix.View, only: [render_to_string: 3]

        def cache_response(conn) do
          content_type = conn
          |> Plug.Conn.get_resp_header("content-type")
          |> hd

          view = view_module(conn)
          template = view_template(conn)

          layout = case conn.assigns |> Map.get(:layout, false) do
            false -> false
            {layout_module, layout_template} ->
              format = layout_formats(conn) |> hd
              {layout_module, "#{layout_template}"}
          end

          assigns = Map.merge(conn.assigns, %{conn: conn, layout: layout})
          response = render_to_string(view, template, assigns)

          PlugEtsCache.Store.set(conn, content_type, response)
          conn
        end
      end
    end
  end
end
