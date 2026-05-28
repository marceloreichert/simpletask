defmodule Simpletask.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Ativa EXLA como backend padrão para NX (Metal no Apple Silicon, CPU nos demais).
    # Garante que o Whisper usa aceleração de hardware em vez do BinaryBackend (Elixir puro).
    Nx.global_default_backend({EXLA.Backend, client: :host})
    Nx.Defn.global_default_options(compiler: EXLA)

    children = [
      SimpletaskWeb.Telemetry,
      Simpletask.Repo,
      {DNSCluster, query: Application.get_env(:simpletask, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Simpletask.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Simpletask.Finch},
      Simpletask.Workers.ScheduleCanceller,
      Simpletask.Serving.Whisper,
      # Start to serve requests, typically the last entry
      SimpletaskWeb.Endpoint,
      TwMerge.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Simpletask.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SimpletaskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
