Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Health
      resources :health

      # Application
      resources :application

      # Root
      root to: "root#index"
    end
  end

  # Redirect Root to current API version root
  root to: redirect("/api/v1")
end
