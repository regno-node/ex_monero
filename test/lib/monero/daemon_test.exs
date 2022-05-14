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

  test "submit_block/1" do
    expected = %{jsonrpc: "2.0", method: "submit_block", params: ["asdf"] }
    assert expected == Daemon.submit_block(["asdf"]).data
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

  test "get_block_header_by_height/1" do
    expected = %{jsonrpc: "2.0", method: "get_block_header_by_height", params: %{
                  height: 1
                }}
    assert expected == Daemon.get_block_header_by_height(1).data
  end

  test "get_block_headers_range/2" do
    expected = %{jsonrpc: "2.0", method: "get_block_headers_range", params: %{
                  start_height: 1, end_height: 100
                }}
    assert expected == Daemon.get_block_headers_range(1, 100).data
  end

  test "get_block/1 height" do
    expected = %{jsonrpc: "2.0", method: "get_block", params: %{ height: 69 }}
    assert expected == Daemon.get_block(69).data
  end

  test "get_block/1 hash" do
    expected = %{jsonrpc: "2.0", method: "get_block", params: %{ hash: "asdf" }}
    assert expected == Daemon.get_block("asdf").data
  end

  test "get_connections/0" do
    expected = %{jsonrpc: "2.0", method: "get_connections", params: nil}
    assert expected == Daemon.get_connections().data
  end

  test "get_info/0" do
    expected = %{jsonrpc: "2.0", method: "get_info", params: nil}
    assert expected == Daemon.get_info().data
  end

  test "hard_fork_info/0" do
    expected = %{jsonrpc: "2.0", method: "hard_fork_info", params: nil}
    assert expected == Daemon.hard_fork_info().data
  end

  test "set_bans/1" do
    bans = [
      %{
        host: "192.168.1.1",
        ban: true,
        seconds: 100000
      }
    ]
    expected = %{jsonrpc: "2.0", method: "set_bans", params: %{ bans: bans }}
    assert expected == Daemon.set_bans(bans).data
  end

  test "get_bans/0" do
    expected = %{jsonrpc: "2.0", method: "get_bans", params: nil}
    assert expected == Daemon.get_bans().data
  end

  #flush_txpool
  #get_output_histogram
  #get_version
  #get_coinbase_tx_sum

  test "get_fee_estimate/0" do
    expected = %{jsonrpc: "2.0", method: "get_fee_estimate", params: nil}
    assert expected == Daemon.get_fee_estimate().data
  end

  #get_alternate_chains
  #relay_tx
  #sync_info
  #get_txpool_backlog

  test "get_height/0" do
    assert "get_height" == Daemon.get_height().action
  end

  #/get_blocks.bin
  #/get_blocks_by_height.bin
  #/get_hashes.bin
  #/get_o_indexes.bin
  #/get_outs.bin
  #/get_transactions
  #/get_alt_blocks_hashes
  #/is_key_image_spent

  test "send_raw_transaction/1" do
    tx_hex = "010002028090c...81a2e3bc0039cb0a02"

    expected = %{
      tx_as_hex: tx_hex,
      do_not_relay: false
    }
    query = Daemon.send_raw_transaction(tx_hex)
    assert "send_raw_transaction" = query.action
    assert expected == query.data
  end

  #/start_mining
  #/stop_mining
  #/mining_status
  #/save_bc

  test "get_peer_list/0" do
    assert "get_peer_list" = Daemon.get_peer_list().action
  end

  #/set_log_hash_rate
  #/set_log_level
  #/set_log_categories
  #/get_transaction_pool
  #/get_transaction_pool_hashes.bin
  #/get_transaction_pool_stats
  #/stop_daemon
  #/get_limit
  #/set_limit
  #/out_peers
  #/in_peers
  #/get_outs
  #/update

end
