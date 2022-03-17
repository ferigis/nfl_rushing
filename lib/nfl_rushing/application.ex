defmodule NFL.Rushing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias NFL.RushingWeb.Endpoint

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NFL.Rushing.Repo,
      # Start the Telemetry supervisor
      NFL.RushingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: NFL.Rushing.PubSub},
      # Start the Endpoint (http/https)
      Endpoint
      # Start a worker by calling: NFL.Rushing.Worker.start_link(arg)
      # {NFL.Rushing.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NFL.Rushing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
