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

  scope "/", SiemensCollection do
    pipe_through :browser

    resources "/", BrandController, except: [:show] do
      resources "/series", SeriesController, except: [:index, :show]
    end

    scope "/profile" do
      get "/", ProfileController, :edit
      put "/", ProfileController, :update
      delete "/:id", ProfileController, :delete
    end

    scope "/collections", as: :collections do
      get "/", CollectionController, :index
      scope "/:user_id" do
        resources "/", ItemController
        scope "/:item_id/images" do
          get "/new", PictureController, :new
          post "/", PictureController, :create
          delete "/:id", PictureController, :delete
          post "/:id/rotate/:direction", PictureController, :rotate
        end
      end
    end

    scope "/:brand_id", as: :catalog do
      resources "/", PhoneController
      scope "/:phone_id" do
        resources "/", PhoneEditionController, except: [:index, :show]
        get "/:edition_id/set_main", PhoneController, :set_main_edition
        get "/:edition_id/add_to_collection", ItemController, :new
        scope "/:edition_id/images" do
          get "/new", PictureController, :new
          post "/", PictureController, :create
          delete "/:id", PictureController, :delete
          post "/:id/rotate/:direction", PictureController, :rotate
        end
      end
    end


  end

  # Other scopes may use custom stacks.
  # scope "/api", SiemensCollection do
  #   pipe_through :api
  # end
end
