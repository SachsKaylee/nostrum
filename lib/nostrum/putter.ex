defmodule Nostrum.Putter do
  @moduledoc since: "NEXTVERSION"
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Nostrum.Putter
      import Nostrum.Putter, only: [defputter: 2]
    end
  end

  @doc """
  Declares a put_* function. Accepts a %__MODULE__{} as first parameter and the declared arguments as the others. The value returned by the do block is the new value that should be assigned to `field`.

  - Automatically generates a @doc if not defined.
  - Automatically generates a @spec if not defined.
  """
  defmacro defputter({field, meta, args}, do: body) do
    arg_names = for {arg_name, _, _} <- args, do: arg_name
    arg_types = for arg <- arg_names, do: {arg, meta, []}
    arity = length(args) + 1
    first_arg_name = hd(arg_names)

    put_fun = :"put_#{field}"

    default_doc = """
    Puts the given #{join_nl(arg_names)} under `:#{field}` in `struct`.
    """

    quote do
      # Generate documentation (unless manually set via @doc)
      current_doc_attr = Module.get_attribute(__MODULE__, :doc)
      example_doc_attr = Module.delete_attribute(__MODULE__, :doc_example)

      case {current_doc_attr, example_doc_attr} do
        {nil, example_doc_attr} when not is_nil(example_doc_attr) ->
          {example_doc_values, example_doc_result} =
            Nostrum.Putter.normalize_example(unquote(first_arg_name), example_doc_attr)

          # Build argument list in order of function args
          arg_values =
            for arg <- unquote(arg_names) do
              case Keyword.fetch(example_doc_values, arg) do
                {:ok, val} -> Macro.to_string(val)
                :error -> "_"
              end
            end

          example =
            """
            ## Examples

            ```elixir
            iex> t = %#{__MODULE__}{}
            ...> #{__MODULE__}.#{unquote(put_fun)}(t, #{Enum.join(arg_values, ", ")})
            %#{__MODULE__}{#{unquote(field)}: #{Macro.to_string(example_doc_result)}}
            ```
            """

          @doc unquote(default_doc) <> example

        {nil, nil} ->
          @doc unquote(default_doc)

        _ ->
          :ok
      end

      # Generate TypeSpec (unless manually set via @spec)
      if not Nostrum.Putter.spec_exists?(__MODULE__, [{unquote(put_fun), unquote(arity)}]) do
        @spec unquote(put_fun)(t(), unquote_splicing(arg_types)) :: t()
      end

      # Generate put_*
      def unquote(put_fun)(%__MODULE__{} = struct, unquote_splicing(args)) do
        value = unquote(body)
        %__MODULE__{struct | unquote(field) => value}
      end
    end
  end

  @doc false
  def normalize_example(_, values: example_doc_values, result: example_doc_result),
    do: {example_doc_values, example_doc_result}

  def normalize_example(first_arg_name, example_doc_value),
    do: {[{first_arg_name, example_doc_value}], example_doc_value}

  @doc """
  Joins a list of strings usually natural language (a, b and c).
  """
  @spec join_nl([String.t()], String.t()) :: String.t()
  def join_nl(strings, acc \\ <<>>)
  def join_nl([last], <<>>), do: "`#{last}`"
  def join_nl([last], acc), do: acc <> " and `#{last}`"
  def join_nl([current | next], <<>>), do: join_nl(next, "`#{current}`")
  def join_nl([current | next], acc), do: join_nl(next, acc <> ", `#{current}`")
  def join_nl([], acc), do: acc

  @doc """
  Checks if the given function in the given module has a spec.

  ## Example


    iex > Nostrum.Putter.spec_exists(Nostrum.Putter, spec_exists?: 2)
    true
  """
  @spec spec_exists?(module(), [{function(), arity()}]) :: boolean()
  def spec_exists?(module, [{fun_name, arity}]) do
    specs = Module.get_attribute(module, :spec) || []

    Enum.any?(specs, fn
      {:spec, {:"::", _, [{spec_fun_name, _, spec_args}, _ret]}, _meta} ->
        spec_fun_name == fun_name and length(spec_args) == arity

      _ ->
        false
    end)
  end
end
