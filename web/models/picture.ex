defmodule SiemensCollection.Picture do
  use SiemensCollection.Web, :model
  use Ecto.Model.Callbacks
  use Arc.Ecto.Model

  schema "pictures" do
    field :url, :string
    belongs_to :phone_edition, SiemensCollection.PhoneEdition
    belongs_to :item, SiemensCollection.Item
    field :image, SiemensCollection.Image.Type

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(url phone_edition_id item_id)

  @required_file_fields ~w()
  @optional_file_fields ~w(image)

  after_delete :delete_from_s3
  def delete_from_s3(changeset) do
    picture = changeset.model
    if picture.image != nil do
      :ok = SiemensCollection.Image.delete({picture.image.file_name, picture})
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
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end

  def get_url(picture, version \\ :original) do
    cond do
      picture == nil ->"https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg"
      picture.image != nil -> SiemensCollection.Image.url({picture.image, picture}, version)
      picture.url != nil || picture.url != "" -> picture.url
      true -> "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg"
    end
  end

  def cover(imageable) do
    if imageable.cover_id != nil do
      imageable.cover
    else
      Enum.at(imageable.pictures, 0)
    end
  end
end
