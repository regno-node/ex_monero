defmodule Monero.DaemonTest do
  use ExUnit.Case, async: true
  alias Monero.Daemon

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :daemon} = Daemon.get_fee_estimate()
  end

  test "get_fee_estimate/0" do
    expected = %{jsonrpc: "2.0", method: "get_fee_estimate", params: nil}
    assert expected == Daemon.get_fee_estimate().data
  end

  test "get_height/0" do
    expected = %{jsonrpc: "2.0", method: "get_height", params: nil}
    assert expected == Daemon.get_height().data
  end

  test "get_block_count/0" do
    expected = %{jsonrpc: "2.0", method: "get_block_count", params: nil}
    assert expected == Daemon.get_block_count().data
  end

  test "send_raw_transaction/1" do
    tx_hex = "010002028090c...81a2e3bc0039cb0a02"

    expected = %{
      jsonrpc: "2.0",
      method: "send_raw_transaction",
      params: %{ tx_as_hex: tx_hex, do_not_relay: false }
    }
    assert expected == Daemon.send_raw_transaction(tx_hex).data
  end
end
