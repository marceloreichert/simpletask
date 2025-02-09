defmodule SimpletaskWeb.Router do
  use SimpletaskWeb, :router

  import SimpletaskWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimpletaskWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpletaskWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpletaskWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:simpletask, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SimpletaskWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SimpletaskWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SimpletaskWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SimpletaskWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SimpletaskWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/modalities", ModalityLive.Index, :index
      live "/modalities/new", ModalityLive.Index, :new
      live "/modalities/:id/edit", ModalityLive.Index, :edit

      live "/modalities/:id", ModalityLive.Show, :show
      live "/modalities/:id/show/edit", ModalityLive.Show, :edit

      live "/units", UnitLive.Index, :index
      live "/units/new", UnitLive.Index, :new
      live "/units/:id/edit", UnitLive.Index, :edit

      live "/units/:id", UnitLive.Show, :show
      live "/units/:id/show/edit", UnitLive.Show, :edit

      live "/rooms", RoomLive.Index, :index
      live "/rooms/new", RoomLive.Index, :new
      live "/rooms/:id/edit", RoomLive.Index, :edit

      live "/rooms/:id", RoomLive.Show, :show
      live "/rooms/:id/show/edit", RoomLive.Show, :edit

      live "/specialties", SpecialtyLive.Index, :index
      live "/specialties/new", SpecialtyLive.Index, :new
      live "/specialties/:id/edit", SpecialtyLive.Index, :edit

      live "/specialties/:id", SpecialtyLive.Show, :show
      live "/specialties/:id/show/edit", SpecialtyLive.Show, :edit

      live "/professionals", ProfessionalLive.Index, :index
      live "/professionals/new", ProfessionalLive.Index, :new
      live "/professionals/:id/edit", ProfessionalLive.Index, :edit

      live "/professionals/:id", ProfessionalLive.Show, :show
      live "/professionals/:id/show/edit", ProfessionalLive.Show, :edit

      live "/sectors", SectorLive.Index, :index
      live "/sectors/new", SectorLive.Index, :new
      live "/sectors/:id/edit", SectorLive.Index, :edit

      live "/sectors/:id", SectorLive.Show, :show
      live "/sectors/:id/show/edit", SectorLive.Show, :edit

      live "/dashboard", DashboardLive.Index, :index
    end
  end

  scope "/", SimpletaskWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SimpletaskWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
