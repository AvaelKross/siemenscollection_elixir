defmodule SiemensCollection.PhoneEdition do
  use SiemensCollection.Web, :model

  schema "phone_editions" do
    field :name, :string, default: "Default"
    field :limited, :boolean, default: false
    field :prototype, :boolean, default: false
    field :notes, :string
    field :photo_url, :string
    field :release, :string

    field :form_factor, :string
    field :java, :boolean, default: true
    field :lte, :boolean, default: false
    field :"3g", :boolean, default: false
    field :memory_card_support, :boolean, default: false
    field :memory_card_type, :string
    field :irda, :boolean, default: false
    field :bluetooth, :boolean, default: false
    field :gprs, :boolean, default: false

    field :network, :string
    field :weight, :string
    field :size, :string
    field :battery, :string

    belongs_to :phone, SiemensCollection.Phone, foreign_key: :phone_id
    has_many :pictures, SiemensCollection.Picture, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(limited prototype notes photo_url phone_id release form_factor 
                      java lte 3g memory_card_support memory_card_type irda bluetooth gprs
                      network weight size battery)

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
