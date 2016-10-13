defmodule KaribuexCli.ResponseSpec do
  use ESpec

  describe "KaribuexCli.Response" do
    context "Bad packet" do
      it "gives error when packet is not correct" do
        {:ok, packet} = Msgpax.pack [3, "abcd", nil,"hello world"]
        expect KaribuexCli.Response.decode(packet) |> to(eq {:error, "Invalid karibu packet format"})
      end
    end

    context "correct packet" do
      it "decodes packet" do
        {:ok, packet} = Msgpax.pack [1, "abcd", nil, "hello world"]
        expect KaribuexCli.Response.decode(packet) |> to(eq {:ok, %KaribuexCli.Response{type: 1, id: "abcd", error: nil, result: "hello world"}})
      end
    end
  end
end
