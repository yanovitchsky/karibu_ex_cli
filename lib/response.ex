defmodule KaribuexCli.Response do
  alias KaribuexCli.Response, as: Response
  defstruct type: nil, id: nil, error: nil, result: nil

  def decode(packet) do
    case Msgpax.unpack(packet) do
      {:ok, [1, id, error, result]} ->
        {:ok, %Response{type: 1, id: id, error: error, result: result}}
      _ ->
        {:error, "Invalid karibu packet format"}
    end
  end
end
