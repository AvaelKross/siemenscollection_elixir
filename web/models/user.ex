defmodule SiemensCollection.User do
  use SiemensCollection.Web, :model
  alias SiemensCollection.Repo

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :name, :string
    field :location, :string

    timestamps
  end

  @required_fields ~w(email encrypted_password name)
  @optional_fields ~w(location)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 3)
  end

  def addict_validate({:ok, _}, user_params) do
    responce = {:ok, []}
    users_with_this_email = Repo.one(from p in SiemensCollection.User, where: p.email == ^user_params["email"], select: count("*"))
    if users_with_this_email > 0 do
      responce = {:error, [email: "Email Address Already in Use"]}
    end
    if String.length(user_params["name"]) < 3 do
      responce = {:error, [name: "Invalid name. It should contain at least 3 chars."]}
    end
    responce
  end

  def addict_validate({:error, errors}, _user_params) do
    #IO.puts "I could do something fancy here. But I won't."
    {:error, errors}
  end

end
