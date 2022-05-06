defmodule ChatterWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: ChatterWeb

      import Plug.Conn
      alias ChatterWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/chatter_web/templates",
        namespace: ChatterWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ChatterWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def plug do
    quote do
      use Phoenix.Controller, namespace: ChatterWeb
      import Plug.Conn
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ChatterWeb.ErrorHelpers
      alias ChatterWeb.Router.Helpers, as: Routes
    end
  end

  def stateful_genserver do
    quote do
      use GenServer

      def reply(response, state) do
        ChatterWeb.State.Bucket.put(@bucket_key, state)
        {:reply, response, state}
      end

      def no_reply(state) do
        ChatterWeb.State.Bucket.put(@bucket_key, state)
        {:noreply, state}
      end
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
