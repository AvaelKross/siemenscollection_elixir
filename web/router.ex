defmodule SiemensCollection.Router do
  use SiemensCollection.Web, :router
  use Addict.RoutesHelper

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

  scope "/" do
    addict :routes
  end

  scope "/", SiemensCollection do
    pipe_through :browser



    scope "/profile" do
      get "/", ProfileController, :edit
      put "/", ProfileController, :update
      delete "/:id", ProfileController, :delete
    end
    scope "/deals", assigns: %{filter: "successful"} do
      get "/successful", DealController, :index, as: :successful_deal
    end
    scope "/deals", assigns: %{filter: "all"} do
      get "/all", DealController, :index, as: :all_deal
    end
    scope "/deals", assigns: %{filter: "failed"} do
      get "/failed", DealController, :index, as: :failed_deal
    end
    resources "/deals", DealController
    get "/deals/:deal_id/item", ItemController, :new

    scope "/collections", as: :collections do
      get "/", CollectionController, :index
      scope "/:user_id" do
        resources "/", ItemController
        scope "/:item_id/images" do
          get "/new", PictureController, :new
          post "/", PictureController, :create
          delete "/:id", PictureController, :delete
          post "/:id/rotate/:direction", PictureController, :rotate
          put "/:id/set_cover", PictureController, :set_cover
        end
      end
    end

    resources "/", BrandController, except: [:show] do
      resources "/series", SeriesController, except: [:index, :show]
    end

    scope "/:brand_id", as: :catalog do
      resources "/", PhoneController
      scope "/:phone_id" do
        resources "/", PhoneEditionController, except: [:index]
        get "/:edition_id/set_main", PhoneController, :set_main_edition
        get "/:edition_id/add_to_collection", ItemController, :new
        scope "/:edition_id/images" do
          get "/new", PictureController, :new
          post "/", PictureController, :create
          delete "/:id", PictureController, :delete
          post "/:id/rotate/:direction", PictureController, :rotate
          put "/:id/set_cover", PictureController, :set_cover
        end
      end
    end


  end

  # Other scopes may use custom stacks.
  # scope "/api", SiemensCollection do
  #   pipe_through :api
  # end
end
