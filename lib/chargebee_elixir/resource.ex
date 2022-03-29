defmodule ChargebeeElixir.Resource do
  @moduledoc """
  Embeds a Chargebee API Resource and accessor methods in a module.

  Under the hood these are `

  ```elixir

  defmodule ExampleResource do
    use CharegbeeElixir.Resource, "example-resource"

    # embbedded_schema from `TypedEctoSchema`
    typed_embedded_schema do
      field(:foo, :string, default: "bar")
      field(:lorum, Ecto.Enum, values: [:ipsum, :dolurum])

      embeds_one("resource", EmbeddedResource)
    end
  end


  #iex> ExampleResource.retrieve(101)
  %Resource{
    username:
  }
  ```
  """
  defmacro __using__(resource) do
    quote do
      alias ChargebeeElixir.Interface

      @derive Jason.Encoder
      # @derive Enumerable
      @resource unquote(resource)
      @resource_plural Inflex.pluralize(@resource)
<<<<<<< Updated upstream
=======

      import TypedEctoSchema,
        only: [
          typed_embedded_schema: 1,
          typed_embedded_schema: 2
        ]

      use Ecto.Schema
      use StructAccess
      @primary_key false
>>>>>>> Stashed changes

      def retrieve(id) do
        id
        |> resource_path()
        |> Interface.get()
        |> Map.get(@resource)
        |> __MODULE__.new!()
      rescue
        ChargebeeElixir.NotFoundError -> nil
      end

      def list(params \\ %{}) do
        # Should pagination be by default?
        case Interface.get(resource_base_path(), params) do
          %{"list" => current_list, "next_offset" => next_offset} ->
            Enum.map(current_list, &Map.get(&1, @resource)) ++
              __MODULE__.list(Map.merge(params, %{"offset" => next_offset}))

          %{"list" => current_list} ->
            Enum.map(current_list, &Map.get(&1, @resource))
        end
        |> Enum.map(&__MODULE__.new!/1)
      end

      def create(params, path \\ "") do
        resource_base_path()
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
        |> __MODULE__.new!()
      end

      def post_resource(resource_id, endpoint, params) do
        resource_id
        |> resource_path()
        |> Kernel.<>(endpoint)
        |> Interface.post(params)
        |> Map.get(@resource)
        |> __MODULE__.new!()
      end

      def create_for_parent(parent_path, params, path \\ "") do
        parent_path
        |> Kernel.<>(resource_base_path())
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
        |> __MODULE__.new!()
      end

      def update(resource_id, params, path \\ "") do
        resource_id
        |> resource_path()
        |> Kernel.<>(path)
        |> Interface.post(params)
        |> Map.get(@resource)
        |> __MODULE__.new!()
      end

      def resource_base_path do
        "/#{@resource_plural}"
      end

      def resource_path(id) do
        "#{resource_base_path()}/#{id}"
      end

      @spec changeset(t(), map() | keyword()) :: Ecto.Changeset.t()
      def changeset(%__MODULE__{} = mod, attrs) do
        fields = __MODULE__.__schema__(:fields)
        embeds = __MODULE__.__schema__(:embeds)

        mod
        |> Ecto.Changeset.cast(attrs, fields -- embeds)
        |> handle_validate()
        |> (&Enum.reduce(embeds, &1, fn field, self ->
              Ecto.Changeset.cast_embed(self, field, [])
            end)).()
      end

      @spec new!(attrs :: map() | keyword()) :: t()
      def new!(attrs) do
        case changeset(%__MODULE__{}, attrs) do
          {:ok, data} -> data
          {:error, changeset} -> apply_action!(changeset, :update)
        end
      end

      defimpl Enumerable do
        def reduce(struct, acc, fun) do
          struct
          |> Map.from_struct()
          |> Enumerable.reduce(acc, fun)
        end

        def member?(struct, args) do
          struct
          |> Map.from_struct()
          |> Enumerable.member?(args)
        end

        def count(struct) do
          struct
          |> Map.from_struct()
          |> Enumerable.count()
        end

        def slice(struct) do
          struct
          |> Map.from_struct()
          |> Enumerable.slice()
        end
      end
    end
  end
end
