defmodule Test.JSONCodec do
  @behaviour Monero.JSON.Codec

  defdelegate encode!(data), to: Jason
  defdelegate encode(data), to: Jason
  defdelegate decode!(data), to: Jason
  defdelegate decode(data), to: Jason
end
