defmodule Monero.Config.Defaults do
  @moduledoc """
  Common defaults and defaults for each of the services
  """

  @common %{
    http_client: Monero.Request.Hackney,
    json_codec: Jason,
    retries: [
      max_attempts: 10,
      base_backoff_in_ms: 10,
      max_backoff_in_ms: 10_000
    ]
  }

  @defaults %{
    wallet: %{
      url: {:system, "MONERO_WALLET_RPC_URL"},
      user: {:system, "MONERO_WALLET_RPC_USER"},
      password: {:system, "MONERO_WALLET_RPC_PASSWORD"}
    },
    daemon: %{
      url: {:system, "MONERO_DAEMON_RPC_URL"},
      user: {:system, "MONERO_DAEMON_RPC_USER"},
      password: {:system, "MONERO_DAEMON_RPC_PASSWORD"}
    }
  }

  @doc """
  Retrieve the default configuration for a service.
  """
  for {service, config} <- @defaults do
    config = Map.merge(config, @common)
    def get(unquote(service)), do: unquote(Macro.escape(config))
  end

  def get(_), do: %{}
end
