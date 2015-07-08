Rails.application.routes.draw do
  namespace :admin do
    get '/', to: 'control#index'
    get 'moderation', to: 'moderation#index'
    get 'email', to: 'control#email'
    get 'stats', to: 'stats#index'
    resources :reports do
      get :delete_content
      get :resolve
      get :deny
      get :reopen
      get :close
    end
    scope '/lists' do
      get 'users', to: 'listings#users'
      post 'add_blogger', to: 'listings#add_blogger'
      post 'remove_blogger', to: 'listings#remove_blogger'
      post 'mass_moderation', to: 'listings#moderate'
    end
  end

  post 'ban_user', to: 'application#ban_user'
    post 'unban_user', to: 'application#unban_user'

  get '/c/:category', to: 'submissions#index', as: 'category'
  get '/search', to: 'submissions#search', as: 'search'

  # Users
  devise_for :users, :controllers => { sessions: 'users/sessions', registrations: 'users/registrations', :omniauth_callbacks => 'users/omniauth_callbacks', :passwords => 'usesr/passwords' }  
  get '/u/:user', to: 'submissions#user', as: 'user_uploads'
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
    # Latest download
    get :download
    resources :comments do
      get :restore
    end
    resources :uploads do
      post :approve
      post :deny
      # Download specific version
      get :download
    end
    resources :images, :only => [:edit, :create, :destroy, :new]
    get :favorite
    resources :videos
    resources :reports
  end

  namespace :blog do
    get '/', to: 'posts#index'
    resources :posts
  end

  resources :uploads do
    post :approve
    post :deny
  end

  resources :comments do
    resources :reports
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      get '/documentation', to: 'documentation#index', defaults: { format: 'html' }
      resources :submissions, :only => [:show, :index], defaults: { :sort => 'popular', :type => 'all' } do
        resources :comments, :only => [:show, :index]
        resources :uploads, :only => [:show, :index]
      end
      scope 'stats' do
        get :submissions, :to => 'submissions#stats'
        get :uploads, :to => 'uploads#stats'
        get :comments, :to => 'comments#stats'
      end
    end
  end

  scope '/api/v0' do
    get '/news', to: 'application#news'
    post '/contact', to: 'application#contact', as: 'contact'
    get '/flush', to: 'application#flush_cache', as: 'flush_cache'
    post '/email', to: 'application#send_email', as: 'email'
  end

  get '/unsubscribe', to: 'application#unsubscribe', as: 'unsubscribe'
end
