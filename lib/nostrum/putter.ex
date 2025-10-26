defmodule Nostrum.Putter do
  @moduledoc since: "NEXTVERSION"
  @moduledoc false

  @doc """
  Defines a putter function, where the key defines the name of the key in the struct that should be set. The name of the declared putter will be put_ followed by the key name.

  Options are:

  - `:custom_doc`: If set to true, no docs will be generated at all.
  - `:doc_value`: If provided, an Example will be generated that sets this value in the struct.
  - `:value_spec`: If the type of value does not have the same name as the key, pass the type spec here.
  """
  defmacro defputter(key, opts \\ []) do
    module_name_pretty =
      __CALLER__.module
      |> to_string()
      |> String.replace_leading("Elixir.", "")

    example =
      case Keyword.get(opts, :doc_value) do
        nil ->
          ""

        doc_value ->
          doc_value_pretty = inspect(doc_value, pretty: true)

          """
          ## Examples

          ```elixir
          iex> t = %#{module_name_pretty}{}
          ...> #{module_name_pretty}.put_#{key}(t, #{doc_value_pretty})
          %#{module_name_pretty}{#{key}: #{doc_value_pretty}}
          ```
          """
      end

    defname = :"put_#{to_string(key)}"

    # The type for the value in the generated typespec. Defaults to the name of the key.
    value_spec =
      Keyword.get(
        opts,
        :value_spec,
        quote do
          unquote(key)()
        end
      )

    doc =
      case Keyword.get(opts, :custom_doc, false) do
        true ->
          quote do
          end

        _ ->
          quote do
            @doc """
            Puts the given `value` under `:#{unquote(key)}` in `#{unquote(module_name_pretty)}`.
            #{unquote(example)}
            """
          end
      end

    quote do
      unquote(doc)
      @spec unquote(defname)(t, unquote(value_spec)) :: t
      def unquote(defname)(%__MODULE__{} = t, value) do
        %__MODULE__{t | unquote(key) => value}
      end
    end
  end
end
