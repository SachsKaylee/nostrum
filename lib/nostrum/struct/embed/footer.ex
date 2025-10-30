defmodule Nostrum.Struct.Embed.Footer do
  @moduledoc """
  Struct representing a Discord embed footer.
  """

  use Nostrum.Putter
  alias Nostrum.Util
  alias Jason.{Encode, Encoder}

  defstruct [
    :text,
    :icon_url,
    :proxy_icon_url
  ]

  defimpl Encoder do
    def encode(footer, options) do
      footer
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Map.new()
      |> Encode.map(options)
    end
  end

  @typedoc "Footer text"
  @type text :: String.t()

  @typedoc "URL of footer icon"
  @type icon_url :: String.t() | nil

  @typedoc "Proxied URL of footer icon"
  @type proxy_icon_url :: String.t() | nil

  @type t :: %__MODULE__{
          text: text,
          icon_url: icon_url,
          proxy_icon_url: proxy_icon_url
        }

  @doc since: "NEXTVERSION"
  @doc_example "nostrum footer"
  defputter text(text) do
    text
  end

  @doc since: "NEXTVERSION"
  @doc_example "https://discord.com/assets/53ef346458017da2062aca5c7955946b.svg"
  defputter icon_url(icon_url) do
    icon_url
  end

  @doc false
  @doc since: "NEXTVERSION"
  defputter proxy_icon_url(proxy_icon_url) do
    proxy_icon_url
  end

  @doc false
  def to_struct(map) do
    new = Map.new(map, fn {k, v} -> {Util.maybe_to_atom(k), v} end)

    struct(__MODULE__, new)
  end
end
