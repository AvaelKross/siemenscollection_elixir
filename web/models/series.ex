defmodule SiemensCollection.Series do
  use SiemensCollection.Web, :model

  schema "series" do
    field :name, :string
    belongs_to :brand, SiemensCollection.Brand
    has_many :phones, SiemensCollection.Phone

    timestamps
  end

  @required_fields ~w(name brand_id)
  @optional_fields ~w()

  # before_delete :remove_foreign_keys
  # def remove_foreign_keys(changeset) do
  #   query = from p in SiemensCollection.Phone, where: p.series_id == ^changeset.model.id
  #   SiemensCollection.Repo.update_all(query, set: [series_id: nil])
  #   changeset
  # end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
