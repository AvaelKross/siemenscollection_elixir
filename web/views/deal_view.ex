defmodule SiemensCollection.DealView do
  use SiemensCollection.Web, :view

  def current_user_id(conn) do
    if Addict.Helper.current_user(conn) do
      Addict.Helper.current_user(conn).id
    else
      nil
    end
  end

  def link_or_text(text, filter, value, link) when filter != value do
    link text, to: link
  end

  def link_or_text(text, filter, value, link) do
    text
  end
end
