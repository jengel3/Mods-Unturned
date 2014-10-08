Rails.application.routes.draw do
  root "static#index"
  resources :submissions do
    resources :downloads
    resources :images
  end
  devise_for :users
end
