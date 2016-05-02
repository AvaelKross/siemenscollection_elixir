defmodule SiemensCollection.Phone do
  use SiemensCollection.Web, :model

  schema "phones" do
    field :name, :string
    field :network, :string
    field :features, :string
    field :weight, :string
    field :size, :string
    field :battery, :string
    field :notes, :string
    field :release, :string
    belongs_to :brand, SiemensCollection.Brand

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(network features weight size battery notes release brand_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
