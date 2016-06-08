defmodule SiemensCollection.Router do
  use SiemensCollection.Web, :router
  use Addict.RoutesHelper
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes
  end

  scope "/" do
    addict :routes
  end

  # scope "/", SiemensCollection do
  #   pipe_through :browser # Use the default browser stack

  #   get "/", BrandController, :index
  #   resources "/phones", PhoneController
  #   resources "/phone_editions", PhoneEditionController
  # end

  scope "/", SiemensCollection, as: :short do
    pipe_through :browser
    get "/", BrandController, :index
    scope "/:brand_id" do
      resources "/", PhoneController
      scope "/:phone_id" do
        resources "/", PhoneEditionController, except: [:index, :show]
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SiemensCollection do
  #   pipe_through :api
  # end
end
