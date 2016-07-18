defmodule SiemensCollection.PhoneEditionView do
  use SiemensCollection.Web, :view

  def full_phone_name(edition) do
    if edition.hide_model_name do
      "#{edition.phone.brand.name} #{edition.name}"
    else
      if edition.name == "Default" || edition.name == "(Default)" do
        "#{edition.phone.brand.name} #{edition.phone.name}"
      else
        "#{edition.phone.brand.name} #{edition.phone.name} #{edition.name}"
      end
    end
  end

  def current_user(conn) do
    Addict.Helper.current_user(conn)
  end

  def is_logged_in(conn) do
    current_user(conn) != nil
  end

  def can_edit(conn) do
    SiemensCollection.Plugs.CheckAdminRights.can_edit(conn)
  end
end
