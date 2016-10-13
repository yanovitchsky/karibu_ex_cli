defmodule KaribuexCli.Request do
  alias KaribuexCli.Request, as: Request
  defstruct type: 0, id: nil, resource: nil, method: nil, params: nil

  def new(resource, method, params) do
    %Request{
      id: SecureRandom.hex(10),
      resource: resource,
      method: method,
      params: params
    }
  end

  def encode(request) do
    to_encode = [request.type, request.id, request.resource, request.method, request.params]
    Msgpax.pack(to_encode)
  end
end
