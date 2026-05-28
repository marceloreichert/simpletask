defmodule SimpletaskWeb.ProfessionalLive.FormComponent do
  use SimpletaskWeb, :live_component

  alias Simpletask.Queries.ProfessionalQuery

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle></:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="professional-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input_core field={@form[:name]} type="text" label="Nome" />
        <.input_core field={@form[:social_name]} type="text" label="Nome social" />
        <.input_core
          field={@form[:specialty_id]}
          type="select"
          label="Especialidade"
          options={@specialty_options}
        />
        <.input_core field={@form[:mothers_name]} type="text" label="Nome da mãe" />
        <.input_core field={@form[:birthday]} type="date" label="Data de nascimento" />
        <.input_core field={@form[:nacionality]} type="text" label="Nacionalidade" />
        <.input_core field={@form[:local_of_birth]} type="text" label="Local de nascimento" />
        <.input_core
          field={@form[:date_of_naturalization]}
          type="date"
          label="Date of naturalization"
        />
        <.input_core
          field={@form[:country_of_naturalization]}
          type="text"
          label="Country of naturalization"
        />
        <.input_core
          field={@form[:document_passport_number]}
          type="text"
          label="Document passport number"
        />
        <.input_core
          field={@form[:document_passport_issue_date]}
          type="date"
          label="Document passport issue date"
        />
        <.input_core
          field={@form[:document_passport_issue_country]}
          type="text"
          label="Document passport issue country"
        />
        <.input_core
          field={@form[:document_passport_expiration_date]}
          type="date"
          label="Document passport expiration date"
        />
        <.input_core field={@form[:email]} type="text" label="Email" />
        <.input_core field={@form[:phone_type]} type="text" label="Phone type" />
        <.input_core field={@form[:phone_ddd]} type="text" label="Phone ddd" />
        <.input_core field={@form[:phone_number]} type="text" label="Phone number" />
        <.input_core field={@form[:address_type]} type="text" label="Address type" />
        <.input_core field={@form[:address_description]} type="text" label="Address description" />
        <.input_core field={@form[:address_number]} type="text" label="Address number" />
        <.input_core field={@form[:address_complement]} type="text" label="Address complement" />
        <.input_core field={@form[:address_district]} type="text" label="Address district" />
        <.input_core field={@form[:address_city]} type="text" label="Address city" />
        <.input_core field={@form[:address_uf]} type="text" label="Address uf" />
        <.input_core field={@form[:address_country]} type="text" label="Address country" />
        <.input_core field={@form[:address_zip]} type="text" label="Address zip" />
        <.input_core field={@form[:document_cpf]} type="text" label="Document cpf" />
        <.input_core field={@form[:document_id_number]} type="text" label="Document id number" />
        <.input_core field={@form[:document_id_uf]} type="text" label="Document id uf" />
        <.input_core field={@form[:document_id_issuer]} type="text" label="Document id issuer" />
        <.input_core
          field={@form[:document_id_issue_date]}
          type="date"
          label="Document id issue date"
        />
        <.input_core field={@form[:document_cns]} type="text" label="Document cns" />
        <.input_core
          field={@form[:document_professional_type]}
          type="text"
          label="Document proffional type"
        />
        <.input_core
          field={@form[:document_professional_number]}
          type="text"
          label="Document profissional number"
        />
        <.input_core
          field={@form[:document_professional_uf]}
          type="text"
          label="Document profissional uf"
        />
        <.input_core
          field={@form[:schedule_consultation_time]}
          type="number"
          label="Tempo de consulta (min)"
        />
        <.input_core
          field={@form[:schedule_time_between_consultation]}
          type="number"
          label="Intervalo entre consultas (min)"
        />
        <.input_core
          field={@form[:private_consultation_price]}
          type="number"
          label="Valor da consulta particular (R$)"
          step="0.01"
          min="0"
        />
        <:actions>
          <.button phx-disable-with="Salvando...">Salvar Dados</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{professional: professional} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(ProfessionalQuery.change_professional(professional))
     end)}
  end

  @impl true
  def handle_event("validate", %{"professional_schema" => professional_params}, socket) do
    changeset =
      ProfessionalQuery.change_professional(socket.assigns.professional, professional_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"professional_schema" => professional_params}, socket) do
    save_professional(socket, socket.assigns.action, professional_params)
  end

  defp save_professional(socket, :edit, professional_params) do
    case ProfessionalQuery.update_professional(socket.assigns.professional, professional_params) do
      {:ok, professional} ->
        notify_parent({:saved, professional})

        {:noreply,
         socket
         |> put_flash(:info, "Profissional atualizado com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_professional(socket, :new, professional_params) do
    params = Map.put(professional_params, "unit_id", socket.assigns.current_user.unit_id)

    case ProfessionalQuery.create_professional(params) do
      {:ok, professional} ->
        notify_parent({:saved, professional})

        {:noreply,
         socket
         |> put_flash(:info, "Profissional criado com sucesso")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
