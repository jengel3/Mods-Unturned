Rails.application.routes.draw do
  root "static#index"
  resources :downloads
  resources :submissions
  devise_for :users
end
