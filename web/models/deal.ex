defmodule SiemensCollection.Deal do
  use SiemensCollection.Web, :model

  schema "deals" do
    field :link, :string
    field :contact_name, :string
    field :contact_email, :string
    field :contact_phone, :string
    field :price, :string
    field :status, :string
    field :notes, :string
    field :from, :string

    belongs_to :phone_edition, SiemensCollection.PhoneEdition
    belongs_to :user, SiemensCollection.User
    has_one :item, SiemensCollection.Item

    timestamps
  end

  @required_fields ~w(phone_edition_id user_id status)
  @optional_fields ~w(link contact_name contact_email contact_phone price status notes from)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def in_progress(query) do
    from deal in query, where: deal.status != "Success" and deal.status != "Failed"
  end

  def successful(query) do
    from deal in query, where: deal.status == "Success"
  end

  def failed(query) do
    from deal in query, where: deal.status == "Failed"
  end

  def for_user(query, user_id) do
    from p in query, where: p.user_id == ^user_id
  end
end
