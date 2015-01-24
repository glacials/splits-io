SplitsIO::Application.routes.draw do
  root 'runs#index'

  match '/experiments(/:action(/:id(.:format)))', controller: :vanity, via: [:get, :post]

  get '/faq', to: 'pages#faq', as: :faq
  get '/why', to: 'pages#why', as: :why

  get  '/upload',     to: 'runs#new', as: :new_run
  post '/upload',     to: 'runs#create' # deprecated; use POST /runs or POST /api/v2/runs
  get  '/cant-parse', to: 'runs#cant_parse', as: :cant_parse
  get  '/random',     to: 'runs#random',     as: :random

  get '/signin/twitch',      to: 'twitch#out', as: :twitch_out
  get '/signin/twitch/auth', to: 'twitch#in',  as: :twitch_in

  devise_for :users
  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy', as: :signout
  end

  get '/search(/:q)',              to: 'search#index' # deprecated
  get '/search(?q=:q)',            to: 'search#index', as: :search
  get '/search?q=:game_shortname', to: 'search#index'

  get '/:id/compare/:comparison_run', to: 'runs#compare',  as: :compare
  get '/:id/download/:program',       to: 'runs#download', as: :download

  get '/u/:id', to: redirect('/users/%{id}') # deprecated; use GET /users/:id

  resources :users, only: [:show] do
    scope module: :users do
      resources :pbs, only: [], module: :pbs do
        collection do
          resource :export, only: [], module: :export do
            collection do
              resources :panels, only: [:index]
            end
          end
        end
      end
    end
    member do
      get :follows
    end
  end

  get '/games/:game_id/:id', to: redirect('/games/%{game_id}/categories/%{id}')

  resources :games, only: [:show] do
    resources :categories, only: [:show], module: :games do
      resources :leaderboards, only: [], module: :categories do
        collection do
          resources :sum_of_bests, only: [:index], module: :leaderboards
        end
      end
    end
  end

  resources :tools, only: [:index]

  get    '/runs',     to: redirect('/'),       as: :runs
  get    '/runs/new', to: redirect('/upload')
  post   '/runs',     to: 'runs#create'
  get    '/:id/edit', to: 'runs#edit',         as: :edit_run
  get    '/:id',      to: 'runs#show',         as: :run
  delete '/:id',      to: 'runs#destroy'

  namespace :api do
    namespace :v3 do
      resources :games, only: [:show] do
        resources :runs, only: [:index], module: :games
        resources :categories, only: [:show] do
          resources :runs, only: [:index], module: :categories
        end
      end
      resources :users, only: [:show] do
        resources :games, only: [], module: :users do
          resources :categories, only: [], module: :games do
            resource :prediction, only: [:show], module: :categories
            resource :pb, only: [:show], module: :categories
            resources :runs, only: [:index], module: :categories
          end
        end
        resources :runs, only: [:index], module: :users
        resources :pbs, only: [:index], module: :users
      end
      resources :runs, only: [:show, :create, :destroy]
    end
    namespace :v2 do
      resources :games,      only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :users,      only: [:index, :show] do
        resources :pbs, only: [:index]
      end
      resources :runs,       only: [:index, :show, :create, :destroy] do
        member do
          delete :user, to: :disown
        end
      end
    end
    namespace :v1 do
      resources :games,      only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :users,      only: [:index, :show]
      resources :runs,       only: [:index, :show, :create, :destroy] do
        member do
          delete :user, to: :disown
        end
      end
    end
  end
end
