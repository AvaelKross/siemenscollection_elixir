defmodule SiemensCollection.PhoneEdition do
  use SiemensCollection.Web, :model

  alias SiemensCollection.{Repo, Picture}

  schema "phone_editions" do
    field :notes, :string
    field :photo_url, :string
    field :release, :string
    field :form_factor, :string
    field :memory_card_type, :string
    field :network, :string
    field :weight, :string
    field :size, :string
    field :battery, :string
    field :made_in, :string

    field :limited, :boolean, default: false
    field :prototype, :boolean, default: false

    field :java, :boolean, default: true
    field :lte, :boolean, default: false
    field :"3g", :boolean, default: false
    field :memory_card_support, :boolean, default: false
    field :irda, :boolean, default: false
    field :bluetooth, :boolean, default: false
    field :gprs, :boolean, default: false


    field :name, :string, default: "Default"
    field :real_name_flag, :boolean, default: false
    field :hide_model_name, :boolean, default: false
    field :operator_edition, :boolean, default: false
    field :operator_name, :string
    field :color_name, :string
    field :real_color_name, :boolean, default: false
    field :additional_name, :string

    belongs_to :phone, SiemensCollection.Phone, foreign_key: :phone_id
    has_many :pictures, Picture
    belongs_to :cover, Picture

    timestamps
  end

  # before_delete :destroy_pictures
  # def destroy_pictures(changeset) do
  #   query = from p in Picture, where: p.phone_edition_id == ^changeset.model.id
  #   pictures = Repo.all(query)
  #   Enum.each pictures, fn pic ->
  #     Repo.delete! pic
  #   end
  #   changeset
  # end

  @required_fields ~w()a
  @optional_fields ~w(name limited prototype notes photo_url phone_id release form_factor
                      java lte 3g memory_card_support memory_card_type irda bluetooth gprs
                      network weight size battery additional_name cover_id hide_model_name real_name_flag
                      color_name real_color_name operator_edition operator_name made_in)a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def owned_amount(edition, user) do
    case {edition, user} do
      {_, nil} -> 0
      {_, _} -> Repo.all(from i in SiemensCollection.Item, where: i.user_id == ^user.id, where: i.phone_edition_id == ^edition.id, select: count(i.id)) |> List.first
    end
  end

end
