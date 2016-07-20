defmodule SiemensCollection.Item do
  use SiemensCollection.Web, :model
  use Ecto.Model.Callbacks

  alias SiemensCollection.{Repo, Picture}

  schema "items" do
    field :notes, :string
    field :condition, :integer, default: 10
    field :released, :string
    field :imei, :string
    field :sw, :string
    field :made_in, :string
    field :calls_time, :string
    field :set, :string
    field :selling, :boolean, default: false
    field :full_set, :boolean, default: false

    belongs_to :phone_edition, SiemensCollection.PhoneEdition
    belongs_to :user, SiemensCollection.User
    has_many :pictures, SiemensCollection.Picture
    belongs_to :cover, Picture

    timestamps
  end

  @required_fields ~w(phone_edition_id user_id)
  @optional_fields ~w(notes condition released imei sw made_in calls_time set selling cover_id full_set)

  before_delete :destroy_pictures
  def destroy_pictures(changeset) do
    query = from p in Picture, where: p.item_id == ^changeset.model.id
    pictures = Repo.all(query)
    Enum.each pictures, fn pic ->
      Repo.delete! pic
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

  def pictures_count(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :pictures),
      select: {p, count(c.id)}
  end

  def cover_image(item) do
    if length(item.pictures) > 0 do
      SiemensCollection.Picture.cover(item)
    else
      SiemensCollection.Picture.cover(item.phone_edition)
    end
  end

  def for_user(query, user_id) do
    from p in query, where: p.user_id == ^user_id
  end
end
