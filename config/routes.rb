SplitsIO::Application.routes.draw do
  root 'runs#index'

  get '/faq', to: 'pages#faq', as: :faq
  get '/why', to: 'pages#why', as: :why
  get '/health', to: 'health#index'

  get  '/upload',     to: 'runs#new', as: :new_run
  get  '/cant-parse', to: 'runs#cant_parse', as: :cant_parse
  get  '/random',     to: 'runs#random',     as: :random

  get  '/convert',    to: 'converts#new'
  post '/convert',    to: 'converts#create'

  get '/search',        to: redirect('/games')
  get '/search/:q',     to: redirect('/games?q=%{q}')
  get '/search(?q=:q)', to: redirect('/games?q=%{q}')

  get '/:id/compare/:comparison_run', to: 'runs#compare',  as: :compare
  get '/:id/download/:program',       to: 'runs#download', as: :download

  get '/u/:id', to: redirect('/users/%{id}') # deprecated; use GET /users/:id

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  resources :sessions, only: [:destroy]

  resources :users, only: [:show, :destroy] do
    scope module: :users do
      resources :rivalries, only: [:index, :new, :create, :destroy]
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

  get '/games',            to: 'games#index', as: :games
  get '/games/:game',      to: 'games#show',  as: :game
  get '/games/:game/edit', to: 'games#edit', as: :edit_game

  post '/games/:game/aliases', to: 'games/aliases#create'

  get '/games/:game/categories',           to: redirect('/games/%{id}')
  get '/games/:game/categories/:category', to: 'games/categories#show', as: :game_category

  get '/games/:game/categories/:category/leaderboards/sum_of_bests',
    to: 'games/categories/leaderboards/sum_of_bests#index',
    as: :game_category_sum_of_bests

  resources :tools, only: [:index]
  resources :settings, only: [:index]

  get    '/runs',            to: redirect('/'), as: :runs
  get    '/runs/new',        to: redirect('/upload')
  get    '/runs/:id/edit',   to: redirect('/%{id}/edit')
  get    '/:id/edit',        to: 'runs#edit', as: :edit_run
  get    '/:run_id/stats',   to: 'runs/stats#index', as: :run_stats
  patch  '/:id',             to: 'runs#update'
  get    '/:id',             to: 'runs#show', as: :run
  delete '/:id',             to: 'runs#destroy'

  namespace :api do
    namespace :v4 do
      match '(/*a(/*b(/*c(/*d))))', via: [:options], to: 'application#options'

      get '/games',       to: 'games#index'
      get '/games/:game', to: 'games#show', as: 'game'

      get '/games/:game/categories', to: 'games/categories#index'
      get '/games/:game/runners',    to: 'games/runners#index'
      get '/games/:game/runs',       to: 'games/runs#index'

      get '/categories/:category', to: 'categories#show', as: 'category'

      get '/categories/:category/:runners', to: 'categories/runners#index'

      get '/runners/:runner', to: 'runners#show', as: 'runner'

      get '/runners/:runner/pbs',        to: 'runners/pbs#index'
      get '/runners/:runner/runs',       to: 'runners/runs#index'
      get '/runners/:runner/games',      to: 'runners/games#index'
      get '/runners/:runner/categories', to: 'runners/categories#index'

      post   '/runs',      to: 'runs#create'
      get    '/runs/:run', to: 'runs#show', as: 'run'
      put    '/runs/:run', to: 'runs#update'
      delete '/runs/:run', to: 'runs#destroy'

      get '/runs/:run/splits', to: 'runs/splits#index'

      post '/convert', to: 'converts#create'
    end

    namespace :v3 do
      match '(/*a(/*b(/*c(/*d))))', via: [:options], to: 'application#options'
      resources :games, only: [:index, :show] do
        resources :runs, only: [:index], module: :games
        resources :categories, only: [:show], module: :games do
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

      resources :runs, only: [:show, :create, :destroy] do
        member do
          post :disown
        end
      end
    end

    namespace :v2 do
      resources :games,      only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :users,      only: [:index, :show] do
        resources :pbs, only: [:index]
      end

      resources :runs,       only: [:index, :show, :create, :destroy] do
        member do
          delete :user, action: :disown
        end
      end
    end
  end
end
