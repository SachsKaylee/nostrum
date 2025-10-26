defmodule Nostrum.Struct.Embed.Footer do
  @moduledoc """
  Struct representing a Discord embed footer.
  """

  require Nostrum.Putter
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
  Nostrum.Putter.defputter(:text, doc_value: "nostrum footer")

  @doc since: "NEXTVERSION"
  Nostrum.Putter.defputter(:icon_url,
    doc_value: "https://discord.com/assets/53ef346458017da2062aca5c7955946b.svg"
  )

  @doc false
  @doc since: "NEXTVERSION"
  Nostrum.Putter.defputter(:proxy_icon_url, custom_doc: true)

  @doc false
  def to_struct(map) do
    new = Map.new(map, fn {k, v} -> {Util.maybe_to_atom(k), v} end)

    struct(__MODULE__, new)
  end
end
