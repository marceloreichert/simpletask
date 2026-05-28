defmodule SimpletaskWeb.UnauthorizedLive do
  use SimpletaskWeb, :live_view

  import Lucideicons, except: [import: 1, quote: 1, menu: 1, link: 1]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Acesso Negado")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-[60vh] gap-6 text-center px-4">
      <div class="flex items-center justify-center w-20 h-20 rounded-full bg-destructive/10">
        <.shield_ban class="w-10 h-10 text-destructive" />
      </div>

      <div class="space-y-2">
        <h1 class="text-3xl font-bold tracking-tight">Acesso Negado</h1>
        <p class="text-muted-foreground max-w-sm">
          Você não tem permissão para acessar esta página.
        </p>
      </div>

      <.link navigate={~p"/"} class="inline-flex items-center gap-2 text-sm font-medium text-primary hover:underline">
        <.arrow_left class="w-4 h-4" />
        Voltar para o início
      </.link>
    </div>
    """
  end
end
