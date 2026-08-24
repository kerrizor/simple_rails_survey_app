Rails.application.routes.draw do
  # Quick default red/green health check
  #
  get "up" => "rails/health#show", as: :rails_health_check

  # The home screen is the list of surveys.
  #
  root "surveys#index"

  resources :surveys, only: [ :index, :new, :create ]
end
