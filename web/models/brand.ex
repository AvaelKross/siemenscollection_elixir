defmodule SiemensCollection.Brand do
  use SiemensCollection.Web, :model
  use Ecto.Model.Callbacks

  alias SiemensCollection.Repo

  schema "brands" do
    field :name, :string
    has_many :phones, SiemensCollection.Phone

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  before_delete :destroy_phones
  def destroy_phones(changeset) do
    query = from p in SiemensCollection.Phone, where: p.brand_id == ^changeset.model.id
    phones = Repo.all(query)
    Enum.each phones, fn phone ->
      Repo.delete! phone
    end
    changeset
  end

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
