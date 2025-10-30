defmodule Nostrum.Struct.Embed.Author do
  @moduledoc """
  Struct representing a Discord embed author.
  """

  alias Nostrum.Util
  alias Jason.{Encode, Encoder}

  defstruct [
    :name,
    :url,
    :icon_url,
    :proxy_icon_url
  ]

  defimpl Encoder do
    def encode(author, options) do
      author
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Map.new()
      |> Encode.map(options)
    end
  end

  @typedoc "Name of the author"
  @type name :: String.t() | nil

  @typedoc "URL of the author"
  @type url :: String.t() | nil

  @typedoc "URL of the author icon"
  @type icon_url :: String.t() | nil

  @typedoc "Proxied URL of author icon"
  @type proxy_icon_url :: String.t() | nil

  @type t :: %__MODULE__{
          name: name,
          url: url,
          icon_url: icon_url,
          proxy_icon_url: proxy_icon_url
        }

  @doc false
  def to_struct(map) do
    new = Map.new(map, fn {k, v} -> {Util.maybe_to_atom(k), v} end)

    struct(__MODULE__, new)
  end

  @doc ~S"""
  Puts the given `name` under `:name` in `author`.
  """
  @spec put_name(t, name()) :: t
  def put_name(%__MODULE__{} = author, name) do
    %__MODULE__{author | name: name}
  end

  @doc ~S"""
  Puts the given `url` under `:url` in `author`.
  """
  @spec put_url(t, url()) :: t
  def put_url(%__MODULE__{} = author, url) do
    %__MODULE__{author | url: url}
  end

  @doc ~S"""
  Puts the given `icon_url` under `:icon_url` in `author`.
  """
  @spec put_icon_url(t, icon_url()) :: t
  def put_icon_url(%__MODULE__{} = author, icon_url) do
    %__MODULE__{author | icon_url: icon_url}
  end
end
