defmodule Monero.Daemon do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/daemon-rpc.html or
  https://lessless.github.io temporarly.
  """

  ## JSON RPC Methods
  ######################

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

  @doc "Full block information can be retrieved by block height."
  def get_block(height) when is_integer(height) do
    rpc_request("get_block", %{ height: height })
  end

  @doc "Full block information can be retrieved by hash."
  def get_block(hash) when is_bitstring(hash) do
    rpc_request("get_block", %{ hash: hash })
  end

  @doc "Retrieve information about incoming and outgoing connections to your node."
  def get_connections() do
    rpc_request("get_connections")
  end

  @doc "Retrieve general information about the state of your node and the network."
  def get_info() do
    rpc_request("get_info")
  end

  @doc "Look up information regarding hard fork voting and readiness."
  def hard_fork_info() do
    rpc_request("hard_fork_info")
  end

  @doc "Ban another node by IP."
  def set_bans(bans) do
    rpc_request("set_bans", %{ bans: bans })
  end

  def ban(host, seconds) when is_bitstring(host) and is_integer(seconds) do
    set_bans([%{ host: host, ban: true, seconds: seconds }])
  end

  def ban(ip, seconds) when is_integer(ip) and is_integer(seconds) do
    set_bans([%{ ip: ip, ban: true, seconds: seconds }])
  end

  @doc "Get list of banned IPs."
  def get_bans() do
    rpc_request("get_bans")
  end

  @doc "Flush all tx ids from transaction pool"
  def flush_txpool() do
    rpc_request("flush_txpool")
  end

  @doc "Flush an array of txids from transaction pool."
  def flush_txpool(txids) when is_list(txids) do
    rpc_request("flush_txpool", %{ txids: txids })
  end

  @doc """
  Get a histogram of output amounts. For all amounts (possibly filtered by parameters),
  gives the number of outputs on the chain for that amount. RingCT outputs count as 0 amount.
  """
  def get_output_histogram(amounts, min_count, max_count, unlocked, recent_cutoff) do
    rpc_request("get_output_histogram", %{
      amounts: amounts,
      min_count: min_count,
      max_count: max_count,
      unlocked: unlocked,
      recent_cutoff: recent_cutoff
    })
  end

  @doc "Get the current node version."
  def get_version() do
    rpc_request("get_version")
  end


  @doc "Get the coinbase amount and the fees amount for n last blocks starting at particular height."
  def get_coinbase_tx_sum(height, count) do
    rpc_request("get_coinbase_tx_sum", %{ height: height, count: count })
  end

  @doc "Gives an estimation on fees per byte."
  @spec get_fee_estimate() :: Monero.Operation.Query.t()
  def get_fee_estimate() do
    rpc_request("get_fee_estimate")
  end

  def get_fee_estimate(grace_blocks) do
    rpc_request("get_fee_estimate", %{ grace_blocks: grace_blocks })
  end

  @doc "Display alternative chains seen by the node."
  def get_alternate_chains() do
    rpc_request("get_alternate_chains")
  end

  @doc "Relay a list of transaction IDs."
  def relay_tx(txids) do
    rpc_request("relay_tx", %{ txids: txids })
  end

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

  ## Other RPC Methods
  #######################

  @doc "Get the node's current height."
  @spec get_height() :: Monero.Operation.Query.t()
  def get_height() do
    request("get_height")
  end

  #/get_blocks.bin
  #/get_blocks_by_height.bin
  #/get_hashes.bin
  #/get_o_indexes.bin
  #/get_outs.bin
  #/get_transactions
  #/get_alt_blocks_hashes
  #/is_key_image_spent

  @doc """
  Broadcast a raw transaction to the network.

  Args:
  * `tx_hex` - Full transaction information as hexidecimal string.
  """
  @spec send_raw_transaction(String.t(), bool()) :: Monero.Operation.Query.t()
  def send_raw_transaction(tx_as_hex, do_not_relay \\ false) do
    request("send_raw_transaction",
      %{tx_as_hex: tx_as_hex, do_not_relay: do_not_relay}
    )
  end

  #/start_mining
  #/stop_mining
  #/mining_status
  #/save_bc

  @doc "Get the known peers list."
  def get_peer_list() do
    request("get_peer_list")
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
