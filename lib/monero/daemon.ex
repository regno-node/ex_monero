defmodule Monero.Daemon do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/daemon-rpc.html or
  https://lessless.github.io temporarly.
  """

  ## JSON RPC Methods
  ######################

  @doc "Look up how many blocks are in the longest chain known to the node."
  @spec get_block_count() :: Monero.Operation.Query.t()
  def get_block_count(), do: rpc_request("get_block_count")

  @spec on_get_block_hash(any) :: Monero.Operation.Query.t()
  @doc "Look up a block's hash by its height."
  def on_get_block_hash(height), do: rpc_request("on_get_block_hash", [height])

  @doc "Get block template on which mining a new block."
  @spec get_block_template(String.t(), non_neg_integer()) :: Monero.Operation.Query.t()
  def get_block_template(wallet_address, reserve_size) do
    rpc_request(
      "get_block_template",
      %{wallet_address: wallet_address, reserve_size: reserve_size}
    )
  end

  # get_miner_data
  # calc_pow (restricted)

  @doc "Submit a mined block to the network"
  @spec submit_block(list(String.t())) :: Monero.Operation.Query.t()
  def submit_block(blocks), do: rpc_request("submit_block", blocks)

  # generateblocks (restricted)

  @doc "Retrieve basic information about the latest block."
  @spec get_last_block_header() :: Monero.Operation.Query.t()
  def get_last_block_header(), do: rpc_request("get_last_block_header")

  @doc "Retrieve basic information about the block with this hash."
  @spec get_block_header_by_hash(String.t()) :: Monero.Operation.Query.t()
  def get_block_header_by_hash(hash), do: rpc_request("get_block_header_by_hash", %{hash: hash})

  @doc "Retrieve basic information about the block with this height."
  @spec get_block_header_by_height(non_neg_integer()) :: Monero.Operation.Query.t()
  def get_block_header_by_height(height), do: rpc_request("get_block_header_by_height", %{height: height})

  @doc "Retrieve basic information about a range of blocks with heights between start_height and end_height."
  @spec get_block_headers_range(non_neg_integer(), non_neg_integer()) :: Monero.Operation.Query.t()
  def get_block_headers_range(start_height, end_height) do
    rpc_request("get_block_headers_range", %{start_height: start_height, end_height: end_height})
  end

  @doc "Retrieve full block information by either its height or hash."
  @spec get_block(bitstring | integer) :: Monero.Operation.Query.t()
  def get_block(height) when is_integer(height), do: rpc_request("get_block", %{height: height})

  def get_block(hash) when is_bitstring(hash), do: rpc_request("get_block", %{hash: hash})

  @doc "Retrieve information about incoming and outgoing connections to your node. (restricted)"
  @spec get_connections :: Monero.Operation.Query.t()
  def get_connections(), do: rpc_request("get_connections")

  @doc "Retrieve general information about the state of your node and the network."
  @spec get_info :: Monero.Operation.Query.t()
  def get_info(), do: rpc_request("get_info")

  @doc "Look up information regarding hard fork voting and readiness."
  @spec hard_fork_info :: Monero.Operation.Query.t()
  def hard_fork_info(), do: rpc_request("hard_fork_info")

  @doc "Ban other nodes by IP. (restricted)"
  @spec set_bans(any) :: Monero.Operation.Query.t()
  def set_bans(bans), do: rpc_request("set_bans", %{bans: bans})

  @doc "Ban a single node. (restricted)"
  @spec ban(bitstring | integer, pos_integer) :: Monero.Operation.Query.t()
  def ban(host, seconds) when is_bitstring(host), do: set_bans([%{host: host, ban: true, seconds: seconds}])
  def ban(ip, seconds) when is_integer(ip), do: set_bans([%{ip: ip, ban: true, seconds: seconds}])

  @doc "Unban a single node. (restricted)"
  @spec unban(bitstring | integer) :: Monero.Operation.Query.t()
  def unban(host) when is_bitstring(host), do: set_bans([%{host: host, ban: false}])
  def unban(ip) when is_integer(ip), do: set_bans([%{ip: ip, ban: false}])

  @doc "Get list of banned IPs. (restricted)"
  @spec get_bans :: Monero.Operation.Query.t()
  def get_bans(), do: rpc_request("get_bans")

  # banned (restricted)

  @doc "Flush all tx ids from transaction pool (restricted)"
  @spec flush_txpool :: Monero.Operation.Query.t()
  def flush_txpool(), do: rpc_request("flush_txpool")

  @doc "Flush an array of txids from transaction pool. (restricted)"
  @spec flush_txpool(list) :: Monero.Operation.Query.t()
  def flush_txpool(txids) when is_list(txids), do: rpc_request("flush_txpool", %{txids: txids})

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
  @spec get_version :: Monero.Operation.Query.t()
  def get_version(), do: rpc_request("get_version")

  @doc "Get the coinbase amount and the fees amount for n last blocks starting at particular height. (restricted)"
  @spec get_coinbase_tx_sum(pos_integer, pos_integer) :: Monero.Operation.Query.t()
  def get_coinbase_tx_sum(height, count), do: rpc_request("get_coinbase_tx_sum", %{height: height, count: count})

  @doc "Gives an estimation on fees per byte."
  @spec get_fee_estimate() :: Monero.Operation.Query.t()
  def get_fee_estimate(), do: rpc_request("get_fee_estimate")

  @spec get_fee_estimate(pos_integer) :: Monero.Operation.Query.t()
  def get_fee_estimate(grace_blocks), do: rpc_request("get_fee_estimate", %{grace_blocks: grace_blocks})

  @doc "Display alternative chains seen by the node. (restricted)"
  @spec get_alternate_chains :: Monero.Operation.Query.t()
  def get_alternate_chains(), do: rpc_request("get_alternate_chains")

  @doc "Relay a list of transaction IDs. (restricted)"
  @spec relay_tx(list) :: Monero.Operation.Query.t()
  def relay_tx(txids), do: rpc_request("relay_tx", %{txids: txids})

  @doc "Get synchronization information (restricted)"
  @spec sync_info() :: Monero.Operation.Query.t()
  def sync_info(), do: rpc_request("sync_info")

  @doc "Get the transaction pool backlog"
  @spec get_txpool_backlog() :: Monero.Operation.Query.t()
  def get_txpool_backlog(), do: rpc_request_binary("get_txpool_backlog")

  @doc "Get output distribution for amounts"
  @spec get_output_distribution(list(non_neg_integer()), bool(), non_neg_integer(), non_neg_integer()) :: Monero.Operation.Query.t()
  def get_output_distribution(amounts, cumulative, from_height, to_height) do
    rpc_request(
      "get_output_distribution",
      %{amounts: amounts, cumulative: cumulative, from_height: from_height, to_height: to_height}
    )
  end

  # prune_blockchain (restricted)
  # flush_cache (restricted)
  # rpc_access_info
  # rpc_access_submit_nonce
  # rpc_access_pay
  # rpc_access_tracking (restricted)
  # rpc_access_data (restricted)
  # rpc_access_account (restricted)

  ## Other RPC Methods
  #######################

  @doc "Get the node's current height."
  @spec get_height() :: Monero.Operation.Query.t()
  def get_height(), do: request("get_height")

  # /get_blocks.bin
  # /get_blocks_by_height.bin
  # /get_hashes.bin
  # /get_o_indexes.bin
  # /get_outs.bin
  # /get_transactions
  # /get_alt_blocks_hashes
  # /is_key_image_spent

  @doc """
  Broadcast a raw transaction to the network.

  Args:
  * `tx_hex` - Full transaction information as hexidecimal string.
  """
  @spec send_raw_transaction(String.t(), bool()) :: Monero.Operation.Query.t()
  def send_raw_transaction(tx_as_hex, do_not_relay \\ false) do
    request(
      "send_raw_transaction",
      %{tx_as_hex: tx_as_hex, do_not_relay: do_not_relay}
    )
  end

  # /start_mining (restricted)
  # /stop_mining (restricted)
  # /mining_status (restricted)
  # /save_bc (restricted)

  @doc "Get the known peers list. (restricted)"
  @spec get_peer_list :: Monero.Operation.Query.t()
  def get_peer_list(), do: request("get_peer_list")

  # /get_public_nodes
  # /set_log_hash_rate (restricted)
  # /set_log_level (restricted)
  # /set_log_categories (restricted)
  # /get_transaction_pool
  # /get_transaction_pool_hashes.bin
  # /get_transaction_pool_hashes
  # /get_transaction_pool_stats
  # /set_bootstrap_daemon (restricted)
  # /stop_daemon (restricted)
  # /get_net_stats (restricted)
  # /get_limit 
  # /set_limit (restricted)
  # /out_peers (restricted)
  # /in_peers (restricted)
  # /get_outs
  # /update (restricted)
  # /get_output_distribution.bin
  # /pop_blocks (restricted)

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
