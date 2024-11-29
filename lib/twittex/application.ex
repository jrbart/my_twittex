defmodule Twittex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TwittexWeb.Telemetry,
      Twittex.Repo,
      {DNSCluster, query: Application.get_env(:twittex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Twittex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Twittex.Finch},
      # Start a worker by calling: Twittex.Worker.start_link(arg)
      # {Twittex.Worker, arg},
      # Start to serve requests, typically the last entry
      TwittexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twittex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TwittexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
