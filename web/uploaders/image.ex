defmodule SiemensCollection.Image do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb, :popup]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(String.downcase(Path.extname(file.file_name)))
  end

  # Define a thumbnail transformation:

  def transform(:original, _) do
    {:convert, "-auto-orient"}
  end

  def transform(:thumb, _) do
    #{:convert, "-auto-orient -thumbnail 250x250> -gravity center -format jpg", :jpg}
    {:convert, fn (path, new_path) -> "-size 250x250 #{path} -auto-orient -thumbnail 250x250> -gravity center -format jpg #{new_path}" end}
  end

  def transform(:popup, _) do
    {:convert, fn (path, new_path) -> "-size 2000x1200 #{path} -auto-orient -thumbnail 2000x1200> -gravity center -format jpg #{new_path}" end}
    # {:convert, "-auto-orient -thumbnail 2000x1200> -gravity center -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_, {_, scope}) do
    "uploads/pictures/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  def s3_object_headers(version, {file, scope}) do
    [content_type: Plug.MIME.path(file.file_name)]
  end
end
