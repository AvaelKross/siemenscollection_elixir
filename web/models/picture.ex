defmodule SiemensCollection.Picture do
  use SiemensCollection.Web, :model
  use Arc.Ecto.Model

  schema "pictures" do
    field :url, :string
    belongs_to :phone_edition, SiemensCollection.PhoneEdition
    belongs_to :item, SiemensCollection.PhoneEdition
    field :image, SiemensCollection.Image.Type

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(url phone_edition_id item_id)

  @required_file_fields ~w()
  @optional_file_fields ~w(image)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end

  def get_url(picture) do
    if is_bitstring(picture.url) && String.length(picture.url) > 0 do
      picture.url
    else
      SiemensCollection.Image.url({picture.image, picture}, :original)
    end
  end
end
