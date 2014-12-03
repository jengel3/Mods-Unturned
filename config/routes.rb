Rails.application.routes.draw do
  # Users
  devise_for :users, :controllers => {:sessions => "sessions"}
  get '/uploads/:user', to: 'submissions#index', as: 'user_uploads'

  # Root
  root "submissions#index"

  # Submissions
  get '/projects/:type', to: 'submissions#index', as: 'projects', defaults: { :type => "asset" }
  resources :submissions do
    get :download
    resources :comments
    resources :uploads do
      get :approve
      get :deny
    end
    resources :images
  end

  # Admin Panel
  scope '/admin' do
    get '/moderation', to: 'moderation#home', as: 'moderation'
  end
end
