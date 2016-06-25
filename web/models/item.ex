defmodule SiemensCollection.Item do
  use SiemensCollection.Web, :model

  schema "items" do
    field :notes, :string
    field :condition, :integer
    field :released, :string
    field :imei, :string
    field :sw, :string
    field :made_in, :string
    field :calls_time, :string
    field :set, :string
    field :selling, :boolean, default: false
    belongs_to :phone_edition, SiemensCollection.PhoneEdition
    belongs_to :user, SiemensCollection.User
    has_many :pictures, SiemensCollection.Picture

    timestamps
  end

  @required_fields ~w(phone_edition_id user_id)
  @optional_fields ~w(notes condition released imei sw made_in calls_time set selling)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def for_user(query, user_id) do
    from p in query, where: p.user_id == ^user_id
  end
end
