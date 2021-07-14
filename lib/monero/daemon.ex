defmodule Monero.Daemon do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/daemon-rpc.html or
  https://lessless.github.io temporarly.
  """

  @doc "Look up how many blocks are in the longest chain known to the node."
  @spec get_block_count() :: Monero.Operation.Query.t()
  def get_block_count() do
    rpc_request("get_block_count")
 end

  @doc "Look up a block's hash by its height."
  def on_get_block_hash(height) do
    rpc_request("on_get_block_hash", [height])
  end

  @doc "Get block template on which mining a new block."
  @spec get_block_template(String.t(), non_neg_integer()) :: Monero.Operation.Query.t()
  def get_block_template(wallet_address, reserve_size) do
    rpc_request(
      "get_block_template",
      %{wallet_address: wallet_address, reserve_size: reserve_size}
    )
  end

  @doc "Submit a mined block to the network"
  @spec submit_block(list(String.t())) :: Monero.Operation.Query.t()
  def submit_block(blocks) do
    rpc_request("submit_block", blocks)
  end

  @doc "Block header information for the most recent block is easily retrieved with this method."
  @spec get_last_block_header() :: Monero.Operation.Query.t()
  def get_last_block_header() do
    rpc_request("get_last_block_header")
  end

  @doc "Block header information can be retrieved using either a block's hash or height. This method includes a block's hash as an input parameter to retrieve basic information about the block."
  @spec get_block_header_by_hash(String.t()) :: Monero.Operation.Query.t()
  def get_block_header_by_hash(hash) do
    rpc_request("get_block_header_by_hash", %{ hash: hash })
  end

  @doc "Similar to get_block_header_by_hash above, this method includes a block's height as an input parameter to retrieve basic information about the block."
  @spec get_block_header_by_height(non_neg_integer()) :: Monero.Operation.Query.t()
  def get_block_header_by_height(height) do
    rpc_request("get_block_header_by_height", %{ height: height })
  end

  @doc "Similar to get_block_header_by_height above, but for a range of blocks. This method includes a starting block height and an ending block height as parameters to retrieve basic information about the range of blocks."
  @spec get_block_headers_range(non_neg_integer(), non_neg_integer()) :: Monero.Operation.Query.t()
  def get_block_headers_range(start_height, end_height) do
    rpc_request("get_block_headers_range", %{ start_height: start_height, end_height: end_height })
  end
  #get_block
  #get_connections
  #get_info
  # hard_fork_info
  #set_bans
  #get_bans
  #flush_txpool
  #get_output_histogram
  #get_version
  #get_coinbase_tx_sum

  @doc "Gives an estimation on fees per byte."
  @spec get_fee_estimate() :: Monero.Operation.Query.t()
  def get_fee_estimate() do
    rpc_request("get_fee_estimate")
  end

  #get_alternate_chains
  #relay_tx

  @doc "Get synchronization information"
  @spec sync_info() :: Monero.Operation.Query.t()
  def sync_info() do
    rpc_request("sync_info")
  end

  @doc "Get the transaction pool backlog"
  @spec get_txpool_backlog() :: Monero.Operation.Query.t()
  def get_txpool_backlog() do
    rpc_request_binary("get_txpool_backlog")
  end

  @doc "Get output distribution for amounts"
  @spec get_output_distribution(list(non_neg_integer()), bool(), non_neg_integer(), non_neg_integer()) :: Monero.Operation.Query.t()
  def get_output_distribution(amounts, cumulative, from_height, to_height) do
    rpc_request("get_output_distribution",
      %{amounts: amounts, cumulative: cumulative, from_height: from_height, to_height: to_height}
    )
  end


  #/get_height
  #/get_blocks.bin
  #/get_blocks_by_height.bin
  #/get_hashes.bin
  #/get_o_indexes.bin
  #/get_outs.bin
  #/get_transactions
  #/get_alt_blocks_hashes
  #/is_key_image_spent
  #/send_raw_transaction
  #/start_mining
  #/stop_mining
  #/mining_status
  #/save_bc
  #/get_peer_list
  #/set_log_hash_rate
  #/set_log_level
  #/set_log_categories
  #/get_transaction_pool
  #/get_transaction_pool_hashes.bin
  #/get_transaction_pool_stats
  #/stop_daemon
  #/get_info (not JSON)
  #/get_limit
  #/set_limit
  #/out_peers
  #/in_peers
  #/start_save_graph
  #/stop_save_graph
  #/get_outs
  #/update

  @doc """
  Broadcast a raw transaction to the network.

  Args:
  * `tx_hex` - Full transaction information as hexidecimal string.
  """
  @spec send_raw_transaction(String.t(), bool()) :: Monero.Operation.Query.t()
  def send_raw_transaction(tx_as_hex, do_not_relay \\ false) do
    rpc_request("send_raw_transaction",
      %{tx_as_hex: tx_as_hex, do_not_relay: do_not_relay}
    )
  end

  @doc "Get the node's current height."
  @spec get_height() :: Monero.Operation.Query.t()
  def get_height() do
    rpc_request("get_height")
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
