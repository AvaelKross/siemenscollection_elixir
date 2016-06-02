defmodule SiemensCollection.PhoneEdition do
  use SiemensCollection.Web, :model

  schema "phone_editions" do
    field :name, :string
    field :limited, :boolean, default: false
    field :prototype, :boolean, default: false
    field :notes, :string
    field :photo_url, :string
    belongs_to :phone, SiemensCollection.Phone, foreign_key: :phone_id

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(limited prototype notes photo_url phone_id)

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
