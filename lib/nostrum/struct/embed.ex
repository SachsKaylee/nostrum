defmodule Nostrum.Struct.Embed do
  @moduledoc ~S"""
  Functions that work on Discord embeds.

  ## Building Embeds

  `Nostrum.Struct.Embed`s can be built using this module's builder functions
  or standard `Map` syntax:

  ```elixir
  iex> import Nostrum.Struct.Embed
  ...> embed =
  ...>   %Nostrum.Struct.Embed{}
  ...>   |> put_title("craig")
  ...>   |> put_description("nostrum")
  ...>   |> put_url("https://google.com/")
  ...>   |> put_timestamp("2016-05-05T21:04:13.203Z")
  ...>   |> put_color(431_948)
  ...>   |> put_field("Field 1", "Test")
  ...>   |> put_field("Field 2", "More test", true)
  ...> embed
  %Nostrum.Struct.Embed{
    title: "craig",
    description: "nostrum",
    url: "https://google.com/",
    timestamp: "2016-05-05T21:04:13.203Z",
    color: 431_948,
    fields: [
      %Nostrum.Struct.Embed.Field{name: "Field 1", value: "Test"},
      %Nostrum.Struct.Embed.Field{name: "Field 2", value: "More test", inline: true}
    ]
  }
  ```

  ## Using structs

  You can also create `Nostrum.Struct.Embed`s from structs, by using the
  `Nostrum.Struct.Embed` module. Here's how the example above could be build using structs

  ```elixir
    defmodule MyApp.MyStruct do
      use Nostrum.Struct.Embed

      defstruct []

      def title(_), do: "craig"
      def description(_), do: "nostrum"
      def url(_), do: "https://google.com/"
      def timestamp(_), do: "2016-05-05T21:04:13.203Z"
      def color(_), do: 431_948

      def fields(_) do
        [
          %Nostrum.Struct.Embed.Field{name: "Field 1", value: "Test"},
          %Nostrum.Struct.Embed.Field{name: "Field 2", value: "More test", inline: true}
        ]
      end
    end

  iex> Nostrum.Struct.Embed.from(%MyApp.MyStruct{})
  %Nostrum.Struct.Embed{
    title: "craig",
    description: "nostrum",
    url: "https://google.com/",
    timestamp: "2016-05-05T21:04:13.203Z",
    color: 431_948,
    fields: [
      %Nostrum.Struct.Embed.Field{name: "Field 1", value: "Test"},
      %Nostrum.Struct.Embed.Field{name: "Field 2", value: "More test", inline: true}
    ]
  }
  ```
  See this modules callbacks for a list of all the functions that can be implemented.

  The implementation of these callbacks is optional. Not implemented functions will simply
  be ignored.
  """

  use Nostrum.Putter
  alias Nostrum.Struct.Embed.{Author, Field, Footer, Image, Provider, Thumbnail, Video}
  alias Nostrum.Util
  alias Jason.{Encode, Encoder}

  defstruct [
    :title,
    :type,
    :description,
    :url,
    :timestamp,
    :color,
    :footer,
    :image,
    :thumbnail,
    :video,
    :provider,
    :author,
    :fields
  ]

  defimpl Encoder do
    def encode(embed, options) do
      embed
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Map.new()
      |> Encode.map(options)
    end
  end

  @typedoc "Title of the embed"
  @type title :: String.t() | nil

  @typedoc "Type of the embed"
  @type type :: String.t() | nil

  @typedoc "Description of the embed"
  @type description :: String.t() | nil

  @typedoc "Url of the embed"
  @type url :: String.t() | nil

  @typedoc "Timestamp of embed content"
  @type timestamp :: String.t() | nil

  @typedoc "Color code of the embed"
  @type color :: integer() | nil

  @typedoc "Footer information"
  @type footer :: Footer.t() | nil

  @typedoc "Image information"
  @type image :: Image.t() | nil

  @typedoc "Thumbnail information"
  @type thumbnail :: Thumbnail.t() | nil

  @typedoc "Video information"
  @type video :: Video.t() | nil

  @typedoc "Provider information"
  @type provider :: Provider.t() | nil

  @typedoc "Author information"
  @type author :: Author.t() | nil

  @typedoc "Fields information"
  @type fields :: [Field.t()] | nil

  @type t :: %__MODULE__{
          title: title,
          type: type,
          description: description,
          url: url,
          timestamp: timestamp,
          color: color,
          footer: footer,
          image: image,
          thumbnail: thumbnail,
          video: video,
          provider: provider,
          author: author,
          fields: fields
        }

  @callback author(struct) :: author()
  @callback color(struct) :: integer() | nil
  @callback fields(struct) :: fields()
  @callback description(struct) :: description()
  @callback footer(struct) :: footer()
  @callback image(struct) :: url()
  @callback thumbnail(struct) :: url()
  @callback timestamp(struct) :: timestamp()
  @callback title(struct) :: title()
  @callback url(struct) :: url()

  defmacro __using__(_) do
    quote do
      @behaviour Nostrum.Struct.Embed

      def author(_), do: nil
      def color(_), do: nil
      def fields(_), do: nil
      def description(_), do: nil
      def footer(_), do: nil
      def image(_), do: nil
      def thumbnail(_), do: nil
      def timestamp(_), do: nil
      def title(_), do: nil
      def url(_), do: nil

      defoverridable(
        author: 1,
        color: 1,
        fields: 1,
        description: 1,
        footer: 1,
        image: 1,
        thumbnail: 1,
        timestamp: 1,
        title: 1,
        url: 1
      )
    end
  end

  @doc false
  defputter type(type) do
    type
  end

  @doc_example "nostrum"
  defputter title(title) do
    title
  end

  @doc_example "An elixir library for the discord API."
  defputter description(description) do
    description
  end

  @doc_example "https://github.com/Kraigie/nostrum"
  defputter url(url) do
    url
  end

  @doc_example "2018-04-21T17:33:51.893000Z"
  defputter timestamp(timestamp) do
    timestamp
  end

  @doc_example 0x6974C
  defputter color(color) do
    color
  end

  @doc_example %PutterExample{
    values: [
      text: "demo text",
      icon_url: "https://bild.de/a.png"
    ],
    result: %Footer{
      text: "demo text",
      icon_url: "https://bild.de/a.png"
    }
  }
  @spec put_footer(t, Footer.text(), Footer.icon_url()) :: t
  defputter footer(text, icon_url) do
    %Footer{
      text: text,
      icon_url: icon_url
    }
  end

  @doc_example %PutterExample{
    values: [
      url: "https://discord.com/assets/af92e60c16b7019f34a467383b31490a.svg"
    ],
    result: %Nostrum.Struct.Embed.Image{
      url: "https://discord.com/assets/af92e60c16b7019f34a467383b31490a.svg"
    }
  }
  @doc_example nil
  @spec put_image(t, Image.url()) :: t
  defputter image(url) do
    case url do
      nil ->
        nil

      _ ->
        %Image{
          url: url
        }
    end
  end

  @doc_example %PutterExample{
    values: [
      url: "https://discord.com/assets/af92e60c16b7019f34a467383b31490a.svg"
    ],
    result: %Nostrum.Struct.Embed.Thumbnail{
      url: "https://discord.com/assets/af92e60c16b7019f34a467383b31490a.svg"
    }
  }
  @doc_example nil
  @spec put_thumbnail(t, Thumbnail.url()) :: t
  defputter thumbnail(url) do
    case url do
      nil ->
        nil

      _ ->
        %Thumbnail{
          url: url
        }
    end
  end

  @doc false
  @spec put_video(t, Video.url()) :: t
  defputter video(url) do
    %Video{
      url: url
    }
  end

  @doc false
  @spec put_provider(t, Provider.name(), Provider.url()) :: t
  defputter provider(name, url) do
    %Provider{
      name: name,
      url: url
    }
  end

  @doc since: "NEXTVERSION"
  defputter author(author) do
    author
  end

  @doc_example %PutterExample{
    values: [
      name: "skippi",
      url: "https://github.com/skippi",
      icon_url: nil
    ],
    result: %Nostrum.Struct.Embed.Author{
      name: "skippi",
      url: "https://github.com/skippi",
      icon_url: nil
    }
  }

  @doc_example %PutterExample{
    values: [
      name: "skippi2",
      url: "https://github.com/skippi2",
      icon_url: nil
    ],
    result: %Nostrum.Struct.Embed.Author{
      name: "skippi2",
      url: "https://github.com/skippi2",
      icon_url: nil
    }
  }

  @spec put_author(t, Author.name(), Author.url(), Author.icon_url()) :: t
  defputter author(name, url, icon_url) do
    %Author{
      name: name,
      url: url,
      icon_url: icon_url
    }
  end

  @doc ~S"""
  Adds a `Nostrum.Struct.Embed.Field` under `:fields` in `embed`.

  ## Examples

  ```elixir
  iex> embed = %Nostrum.Struct.Embed{}
  ...> Nostrum.Struct.Embed.put_field(embed, "First User", "b1nzy")
  %Nostrum.Struct.Embed{
    fields: [
      %Nostrum.Struct.Embed.Field{name: "First User", value: "b1nzy"}
    ]
  }

  iex> embed = %Nostrum.Struct.Embed{
  ...>   fields: [
  ...>     %Nostrum.Struct.Embed.Field{name: "First User", value: "b1nzy"}
  ...>   ]
  ...> }
  ...> Nostrum.Struct.Embed.put_field(embed, "Second User", "Danny")
  %Nostrum.Struct.Embed{
    fields: [
      %Nostrum.Struct.Embed.Field{name: "First User", value: "b1nzy"},
      %Nostrum.Struct.Embed.Field{name: "Second User", value: "Danny"}
    ]
  }
  ```
  """
  @spec put_field(t, Field.name(), Field.value(), Field.inline()) :: t
  def put_field(embed, name, value, inline \\ nil)

  def put_field(%__MODULE__{fields: fields} = embed, name, value, inline) when is_list(fields) do
    field = %Field{
      name: name,
      value: value,
      inline: inline
    }

    %__MODULE__{embed | fields: fields ++ [field]}
  end

  def put_field(embed, name, value, inline) do
    put_field(%__MODULE__{embed | fields: []}, name, value, inline)
  end

  @doc """
  Create an embed from a struct that implements the `Nostrum.Struct.Embed` behaviour
  """
  def from(%module{} = struct) do
    # checks if the struct implements the behaviour
    if not Enum.member?(module.module_info(:attributes), {:behaviour, [__MODULE__]}) do
      raise "#{module} does not implement the behaviour #{__MODULE__}"
    end

    embed =
      %__MODULE__{}
      |> put_color(module.color(struct))
      |> put_description(module.description(struct))
      |> put_image(module.image(struct))
      |> put_thumbnail(module.thumbnail(struct))
      |> put_timestamp(module.timestamp(struct))
      |> put_title(module.title(struct))
      |> put_url(module.url(struct))

    embed =
      case module.author(struct) do
        %Author{} = author -> put_author(embed, author.name, author.url, author.icon_url)
        nil -> embed
        other -> raise "\"#{inspect(other)}\" is invalid for type author()"
      end

    embed =
      case module.footer(struct) do
        %Footer{} = footer -> put_footer(embed, footer.text, footer.icon_url)
        nil -> embed
        other -> raise "\"#{inspect(other)}\" is invalid for type footer()"
      end

    struct
    |> module.fields()
    |> List.wrap()
    |> Enum.reduce(embed, fn
      %Field{} = field, embed -> put_field(embed, field.name, field.value, field.inline)
      other, _ -> raise "\"#{inspect(other)}\" is invalid for type fields()"
    end)
  end

  # TODO: Jump down the rabbit hole
  @doc false
  def p_encode do
    %__MODULE__{}
  end

  @doc false
  def to_struct(map) do
    new =
      map
      |> Map.new(fn {k, v} -> {Util.maybe_to_atom(k), v} end)
      |> Map.update(:footer, nil, &Util.cast(&1, {:struct, Footer}))
      |> Map.update(:image, nil, &Util.cast(&1, {:struct, Image}))
      |> Map.update(:thumbnail, nil, &Util.cast(&1, {:struct, Thumbnail}))
      |> Map.update(:video, nil, &Util.cast(&1, {:struct, Video}))
      |> Map.update(:provider, nil, &Util.cast(&1, {:struct, Provider}))
      |> Map.update(:author, nil, &Util.cast(&1, {:struct, Author}))
      |> Map.update(:fields, nil, &Util.cast(&1, {:list, {:struct, Field}}))

    struct(__MODULE__, new)
  end
end
