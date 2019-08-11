defmodule PhonesCollectionWeb.Item do
  use SiemensCollection.Web, :model

  alias PhonesCollectionWeb.{Repo, Picture}

  schema "items" do
    field :notes, :string
    field :condition, :integer, default: 10
    field :released, :string
    field :imei, :string
    field :sw, :string
    field :calls_time, :string
    field :set, :string
    field :selling, :boolean, default: false
    field :full_set, :boolean, default: false

    belongs_to :phone_edition, PhonesCollectionWeb.PhoneEdition
    belongs_to :user, PhonesCollectionWeb.User
    has_many :pictures, PhonesCollectionWeb.Picture
    belongs_to :cover, Picture
    belongs_to :deal, PhonesCollectionWeb.PhoneEdition

    timestamps
  end

  @required_fields ~w(phone_edition_id user_id)a
  @optional_fields ~w(notes condition released imei sw calls_time set selling cover_id full_set deal_id)a

  # before_delete :destroy_pictures
  # def destroy_pictures(changeset) do
  #   query = from p in Picture, where: p.item_id == ^changeset.model.id
  #   pictures = Repo.all(query)
  #   Enum.each pictures, fn pic ->
  #     Repo.delete! pic
  #   end
  #   changeset
  # end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_deal
  end

  defp validate_deal(changeset) do
    deal_id = get_field(changeset, :deal_id)
    user_id = get_field(changeset, :user_id)
    validate_deal_owner(changeset, deal_id, user_id)
  end

  defp validate_deal_owner(changeset, deal_id, user_id) when deal_id != nil do
    deal = Repo.get!(PhonesCollectionWeb.Deal, deal_id)
    if deal.user_id != user_id do
      add_error(changeset, :deal_id, "You shouldn't be here")
    else
      changeset
    end
  end
  defp validate_deal_owner(changeset, _, _), do: changeset

  def pictures_count(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :pictures),
      select: {p, count(c.id)}
  end

  def cover_image(item) do
    if length(item.pictures) > 0 do
      PhonesCollectionWeb.Picture.cover(item)
    else
      PhonesCollectionWeb.Picture.cover(item.phone_edition)
    end
  end

  def for_user(query, user_id) do
    from p in query, where: p.user_id == ^user_id
  end
end
