defmodule Nostrum.Struct.Embed.Thumbnail do
  @moduledoc """
  Struct representing a Discord embed thumbnail.
  """

  alias Nostrum.Util
  alias Jason.{Encode, Encoder}

  defstruct [
    :url,
    :proxy_url,
    :height,
    :width
  ]

  defimpl Encoder do
    def encode(thumbnail, options) do
      thumbnail
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Map.new()
      |> Encode.map(options)
    end
  end

  @typedoc "Source URL of the thumbnail"
  @type url :: String.t() | nil

  @typedoc "URL of thumbnail icon"
  @type proxy_url :: String.t() | nil

  @typedoc "Height of the thumbnail"
  @type height :: integer | nil

  @typedoc "Width of the thumbnail"
  @type width :: integer | nil

  @type t :: %__MODULE__{
          url: url,
          proxy_url: proxy_url,
          height: height,
          width: width
        }

  @doc false
  def to_struct(map) do
    new = Map.new(map, fn {k, v} -> {Util.maybe_to_atom(k), v} end)

    struct(__MODULE__, new)
  end

  @doc ~S"""
  Puts the given `url` under `:url` in `thumbnail`.
  """
  @spec put_url(t, url()) :: t
  def put_url(%__MODULE__{} = thumbnail, url) do
    %__MODULE__{thumbnail | url: url}
  end
end
