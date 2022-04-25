defmodule Monero.DaemonTest do
  use ExUnit.Case, async: true
  alias Monero.Daemon

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :daemon} = Daemon.get_fee_estimate()
  end

  test "get_block_count/0" do
    expected = %{jsonrpc: "2.0", method: "get_block_count", params: nil}
    assert expected == Daemon.get_block_count().data
  end

  test "on_get_block_hash/0" do
    expected = %{jsonrpc: "2.0", method: "on_get_block_hash", params: [12345]}
    assert expected == Daemon.on_get_block_hash(12345).data
  end

  test "get_block_template/2" do
    expected = %{jsonrpc: "2.0", method: "get_block_template", params: %{
                    wallet_address: "asdf", reserve_size: 24
                 }}
    assert expected == Daemon.get_block_template("asdf", 24).data
  end

  test "get_last_block_header/0" do
    expected = %{jsonrpc: "2.0", method: "get_last_block_header", params: nil}
    assert expected == Daemon.get_last_block_header().data
  end

  test "get_block_header_by_hash/1" do
    expected = %{jsonrpc: "2.0", method: "get_block_header_by_hash", params: %{
                    hash: "asdf"
                 }}
    assert expected == Daemon.get_block_header_by_hash("asdf").data
  end

  test "submit_block/1" do
    expected = %{jsonrpc: "2.0", method: "submit_block", params: ["asdf"] }
    assert expected == Daemon.submit_block(["asdf"]).data
  end

  test "get_fee_estimate/0" do
    expected = %{jsonrpc: "2.0", method: "get_fee_estimate", params: nil}
    assert expected == Daemon.get_fee_estimate().data
  end

  test "get_height/0" do
    expected = %{jsonrpc: "2.0", method: "get_height", params: nil}
    assert expected == Daemon.get_height().data
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
