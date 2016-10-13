defmodule KaribuexCli.RequestSpec do
  use ESpec

  describe "KaribuexCli.Request" do
    it "encodes request" do
      request = KaribuexCli.Request.new("XenaController", "query", [10])
      res = {:ok, packet} = KaribuexCli.Request.encode(request)
      {:ok,resp} = Msgpax.unpack(packet)
      [type, _id, resource, method, params] = resp

      expect type |> to(eq 0)
      expect resource |> to(eq "XenaController")
      expect method |> to(eq "query")
      expect List.first(params)  |> to(eq 10)
      expect (List.first(params) |> is_integer) |> to(be_true())
    end
  end
end
