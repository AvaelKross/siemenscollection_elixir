defmodule SiemensCollection.Phone do
  use SiemensCollection.Web, :model

  alias SiemensCollection.Repo

  schema "phones" do
    field :name, :string
    field :notes, :string
    belongs_to :brand, SiemensCollection.Brand
    belongs_to :series, SiemensCollection.Series

    has_many :phone_editions, SiemensCollection.PhoneEdition

    belongs_to :main_edition, SiemensCollection.PhoneEdition

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(notes brand_id main_edition_id series_id)

  # before_delete :destroy_editions
  # def destroy_editions(changeset) do
  #   query = from p in SiemensCollection.PhoneEdition, where: p.phone_id == ^changeset.model.id
  #   editions = Repo.all(query)
  #   Enum.each editions, fn edition ->
  #     Repo.delete! edition
  #   end
  #   changeset
  # end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  def changeset_on_create(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:phone_editions, required: false)
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def editions_count(%{id: phone_id}) do
    query = from(pe in SiemensCollection.PhoneEdition, where: pe.phone_id == ^phone_id, select: count(pe.id))
    List.first SiemensCollection.Repo.all(query)
  end

  def editions_count(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :phone_editions),
      select: {p, count(c.id)}
  end

  def cover_image(phone) do
    if phone.main_edition != nil do
      SiemensCollection.Picture.cover(phone.main_edition)
    else
      nil
    end
  end

  def for_brand(query, brand_id) do
    from p in query, where: p.brand_id == ^brand_id
  end
end
