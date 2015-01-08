Rails.application.routes.draw do
  namespace :admin do
  get 'stats/index'
  end

  namespace :admin do
  get 'listings/index'
  end

  namespace :admin do
  get 'moderation/index'
  end

  # Users
  devise_for :users, :controllers => {:sessions => 'sessions'}
  get '/uploads/:user', to: 'submissions#index', as: 'user_uploads'

  # Root
  root 'home#home'

  get '/home', to: 'home#home'

  # Maintenance
  get :maintenance, to: 'application#maintenance'

  # About Page
  get :about, to: 'home#about'

  # Submissions
  get '/projects/:type', to: 'submissions#index', as: 'projects', defaults: { :type => 'all' }
  resources :submissions do
    get :download
    resources :comments
    resources :uploads do
      get :approve
      get :deny
    end
    resources :images
    get :favorite
    resources :videos
  end

  # Admin Panel
  namespace :admin do
    resources :moderation, controller: :moderation
    # get '/moderation', to: 'moderation#home', as: 'moderation'
  end

  scope '/api' do
    get '/news', to: 'application#news'
    post '/tohtml', to: 'application#tohtml'
    post '/contact', to: 'application#contact', as: 'contact'
  end
end
