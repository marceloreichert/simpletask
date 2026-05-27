defmodule SimpletaskWeb.UserLive.Index do
  use SimpletaskWeb, :live_view

  alias Simpletask.Queries.AccountQuery
  alias Simpletask.Queries.ProfessionalQuery

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    users = AccountQuery.list_users(user)
    professionals = ProfessionalQuery.list_professionals(user)

    professional_options =
      [{"Nenhum", nil}] ++
        Enum.map(professionals, fn p ->
          label = "#{p.name}#{if p.specialty, do: " — #{p.specialty.name}", else: ""}"
          {label, p.id}
        end)

    {:ok,
     socket
     |> assign(:page_title, "Usuários")
     |> assign(:users, users)
     |> assign(:professional_options, professional_options)
     |> assign(:editing_id, nil)}
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket) do
    {:noreply, assign(socket, :editing_id, id)}
  end

  @impl true
  def handle_event("cancel", _, socket) do
    {:noreply, assign(socket, :editing_id, nil)}
  end

  @impl true
  def handle_event("link_professional", %{"user_id" => user_id, "professional_id" => prof_id}, socket) do
    professional_id = if prof_id == "", do: nil, else: prof_id

    case AccountQuery.update_user_professional(user_id, professional_id) do
      {:ok, _} ->
        users = AccountQuery.list_users(socket.assigns.current_user)

        {:noreply,
         socket
         |> assign(:users, users)
         |> assign(:editing_id, nil)
         |> put_flash(:info, "Vínculo atualizado com sucesso")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Erro ao atualizar vínculo")}
    end
  end
end
