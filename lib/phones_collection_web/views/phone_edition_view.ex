defmodule PhonesCollectionWeb.PhoneEditionView do
  use SiemensCollection.Web, :view

  def full_phone_name(edition, ignore_default \\ true, separator \\ "") do
    brand_part = "#{edition.phone.brand.name} "
    phone_name_part = phone_name(edition)
    edition_part = full_edition_name(edition, ignore_default)

    brand_part <> phone_name_part <> separator <> edition_part
  end

  def phone_name(edition) do
    if edition.hide_model_name, do: "", else: "#{edition.phone.name} "
  end

  def full_edition_name(edition, ignore_default \\ true) do
    edition_part = if ignore_default && (edition.name == "Default" || edition.name == "(Default)") do
      ""
    else
      "#{edition.name}"
    end

    if edition.color_name != "" && edition.color_name != nil do
      edition_part = edition_part <> " #{edition.color_name}"
    end
    if edition.operator_edition do
      edition_part = edition_part <> " #{edition.operator_name}"
    end
    edition_part = if ignore_default && (edition.additional_name == "Default" || edition.additional_name == "(Default)") do
      edition_part
    else
      edition_part <> " #{edition.additional_name}"
    end
  end

  def current_user(conn) do
    Addict.Helper.current_user(conn)
  end

  def is_logged_in(conn) do
    current_user(conn) != nil
  end

  def can_edit(conn) do
    PhonesCollectionWeb.Plugs.CheckAdminRights.can_edit(conn)
  end
end
