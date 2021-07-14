defmodule Monero.Daemon do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/daemon-rpc.html or
  https://lessless.github.io temporarly.
  """

  @doc "Lookup transaction fee estimate in atomic units"
  @spec get_fee_estimate() :: Monero.Operation.Query.t()
  def get_fee_estimate() do
    rpc_request("get_fee_estimate")
  end

  @doc "Get the node's current height."
  @spec getheight() :: Monero.Operation.Query.t()
  def getheight() do
    request("getheight")
  end

  @doc """
  Broadcast a raw transaction to the network.

  Args:
  * `tx_hex` - Full transaction information as hexidecimal string.
  """
  @spec sendrawtransaction(String.t()) :: Monero.Operation.Query.t()
  def sendrawtransaction(tx_hex) do
    request("sendrawtransaction", %{tx_as_hex: tx_hex})
  end

  ## Request
  ######################

  defp rpc_request(method, params \\ nil) do
    request("json_rpc", %{jsonrpc: "2.0", method: method, params: params})
  end

  defp request(action, data \\ %{}) do
    path = "/#{action}"

    %Monero.Operation.Query{
      action: action,
      path: path,
      data: data,
      service: :daemon,
      parser: &Monero.Daemon.Parser.parse/3
    }
  end

  defp rpc_request_binary(method, params \\ nil) do
    request_binary("json_rpc", %{jsonrpc: "2.0", method: method, params: params})
  end

  defp request_binary(action, data \\ %{}) do
    path = "/#{action}"

    %Monero.Operation.Query{
      action: action,
      path: path,
      data: data,
      service: :daemon,
      parser: &Monero.Daemon.Parser.parse_binary/3
    }
  end
end
