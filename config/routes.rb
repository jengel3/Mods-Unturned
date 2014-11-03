Rails.application.routes.draw do
  root "submissions#index"
  get '/projects/:type', to: 'submissions#index', as: 'projects', defaults: { :type => "asset" }
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
  get '/uploads/:user', to: 'submissions#index', as: 'user_uploads'
end
