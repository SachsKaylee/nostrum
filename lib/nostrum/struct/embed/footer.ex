defmodule Nostrum.Struct.Embed.Footer do
  @moduledoc """
  Struct representing a Discord embed footer.
  """

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

  @doc false
  def to_struct(map) do
    new = Map.new(map, fn {k, v} -> {Util.maybe_to_atom(k), v} end)

    struct(__MODULE__, new)
  end

  @doc ~S"""
  Puts the given `text` under `:text` in `footer`.
  """
  @spec put_text(t, text()) :: t
  def put_text(%__MODULE__{} = footer, text) do
    %__MODULE__{footer | text: text}
  end

  @doc ~S"""
  Puts the given `icon_url` under `:icon_url` in `footer`.
  """
  @spec put_icon_url(t, icon_url()) :: t
  def put_icon_url(%__MODULE__{} = footer, icon_url) do
    %__MODULE__{footer | icon_url: icon_url}
  end
end
