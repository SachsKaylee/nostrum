defmodule Nostrum.Struct.Embed.Field do
  @moduledoc """
  Struct representing a Discord embed field.
  """

  alias Nostrum.Util
  alias Jason.{Encode, Encoder}

  defstruct [
    :name,
    :value,
    :inline
  ]

  defimpl Encoder do
    def encode(field, options) do
      field
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Map.new()
      |> Encode.map(options)
    end
  end

  @typedoc "Name of the field"
  @type name :: String.t()

  @typedoc "Value of the field"
  @type value :: String.t()

  @typedoc "Whether the field should display as inline"
  @type inline :: boolean | nil

  @type t :: %__MODULE__{
          name: name,
          value: value,
          inline: inline
        }

  @doc false
  def to_struct(map) do
    new = Map.new(map, fn {k, v} -> {Util.maybe_to_atom(k), v} end)

    struct(__MODULE__, new)
  end

  @doc ~S"""
  Puts the given `name` under `:name` in `field`.
  """
  @spec put_name(t, name()) :: t
  def put_name(%__MODULE__{} = field, name) do
    %__MODULE__{field | name: name}
  end

  @doc ~S"""
  Puts the given `value` under `:value` in `field`.
  """
  @spec put_value(t, value()) :: t
  def put_value(%__MODULE__{} = field, value) do
    %__MODULE__{field | value: value}
  end

  @doc ~S"""
  Puts the given `inline` under `:inline` in `field`.
  """
  @spec put_inline(t, inline()) :: t
  def put_inline(%__MODULE__{} = field, inline) do
    %__MODULE__{field | inline: inline}
  end
end
