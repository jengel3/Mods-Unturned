Rails.application.routes.draw do
  root "static#index"
  resources :submissions do
    resources :downloads
  end
  devise_for :users
end
