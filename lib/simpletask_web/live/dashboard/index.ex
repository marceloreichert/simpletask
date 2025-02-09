defmodule SimpletaskWeb.DashboardLive.Index do
  use SimpletaskWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
