Rails.application.routes.draw do
  root "static#index"
  resources :submissions do
    resources :comments
    resources :downloads do
      get :approve
      get :deny
    end
    resources :images
  end
  devise_for :users
  get '/moderation', to: 'moderation#home', as: 'moderation'
  get '/uploads/:user', to: 'static#index', as: 'user_uploads'
end
