Rails.application.routes.draw do
  namespace :admin do
    get '/', to: 'control#index'
    get 'moderation', to: 'moderation#index'
    resources :reports do
      get :delete_content
      get :resolve
      get :deny
      get :reopen
      get :close
    end
  end

  # Users
  devise_for :users, :controllers => { sessions: 'sessions', registrations: 'registrations', :omniauth_callbacks => 'users/omniauth_callbacks', :passwords => 'passwords' }  
  get '/uploads/:user', to: 'submissions#index', as: 'user_uploads'
  get '/accounts/finish_steam', to: 'application#finish_steam', as: 'finish_steam'
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
    resources :comments do
      get :restore
    end
    resources :uploads do
      post :approve
      post :deny
    end
    resources :images
    get :favorite
    resources :videos
    resources :reports
  end

  resources :uploads do
    post :approve
    post :deny
  end

  resources :comments do
    resources :reports
  end

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :submissions, :only => [:show, :index], defaults: { :sort => 'popular', :type => 'all' }
    end
  end

  scope '/api/v0' do
    get '/search', to: 'submissions#index', as: 'search'
    get '/news', to: 'application#news'
    post '/tohtml', to: 'application#tohtml'
    post '/contact', to: 'application#contact', as: 'contact'
    get '/flush', to: 'application#flush_cache', as: 'flush_cache'
  end

  get '/unsubscribe', to: 'application#unsubscribe', as: 'unsubscribe'
end
