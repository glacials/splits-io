Rails.application.routes.draw do
  namespace :admin do
    resources :games
    resources :game_aliases
    resources :categories

    resources :runs
    resources :segments
    resources :segment_histories

    resources :users
    resources :patreon_users
    resources :rivalries

    root to: 'runs#index'
  end

  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
  end

  root 'runs#index'

  get '/faq',       to: 'pages#faq',            as: :faq
  get '/read-only', to: 'pages#read_only_mode', as: :read_only_mode

  get '/why/permalinks', to: 'why#permalinks', as: :why_permalinks
  get '/why/darkmode',   to: 'why#darkmode',   as: :why_darkmode
  get '/why/readonly',   to: 'why#readonly',   as: :why_readonly

  get '/health', to: 'health#index'

  get  '/upload',     to: 'runs#new',        as: :new_run
  get  '/cant-parse', to: 'runs#cant_parse', as: :cant_parse
  get  '/random',     to: 'runs#random',     as: :random

  get  '/convert', to: 'converts#new'

  get '/search',    to: 'search#index'
  get '/search/:q', to: redirect('/search?q=%{q}')

  get '/:run/compare/:comparison_run', to: 'runs#compare',  as: :compare
  get '/:run/download/:timer',         to: 'runs#download', as: :download

  get '/u/:user', to: redirect('/users/%{user}') # deprecated; use GET /users/:user

  get '/auth/patreon',          to: 'patreon_users#out'
  get '/auth/patreon/callback', to: 'patreon_users#in'
  get '/auth/patreon/unlink',   to: 'patreon_users#unlink'

  get '/auth/failure', to: 'sessions#failure'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :sessions, only: [:destroy]

  get    '/users/:user', to: 'users#show', as: :user
  delete '/users/:user', to: 'users#destroy'

  get    '/rivals',             to: redirect('/rivalries')
  get    '/rivalries',          to: 'rivalries#index',   as: :rivalries
  get    '/rivalries/new',      to: 'rivalries#new',     as: :new_rivalry
  post   '/rivalries',          to: 'rivalries#create'
  delete '/rivalries/:rivalry', to: 'rivalries#destroy', as: :rivalry

  get '/users/:user/pbs/export/panels', to: 'users/pbs/export/panels#index', as: :user_panels

  get '/users/:user/pbs/:game/:category(/*trailing_path)', to: 'users/pbs#show', as: :user_pb

  get   '/games',            to: redirect('/search')
  get   '/games(?q=:q)',     to: redirect('/search?q=%{q}')
  get   '/games/:game',      to: 'games#show',  as: :game
  get   '/games/:game/edit', to: 'games#edit',  as: :edit_game
  patch '/games/:game',      to: 'games#update'

  post '/games/:game/aliases', to: 'games/aliases#create', as: :game_aliases

  get '/games/:game/categories',           to: redirect('/games/%{game}')
  get '/games/:game/categories/:category', to: 'games/categories#show', as: :game_category

  get '/games/:game/categories/:category/leaderboards/sum_of_bests',
      to: 'games/categories/leaderboards/sum_of_bests#index',
      as: :game_category_sum_of_bests

  get '/tools', to: 'tools#index'

  get    '/settings', to: 'settings#index',       as: :settings

  get    '/settings/applications/new',            to: 'applications#new',                as: :new_application
  post   '/settings/applications',                to: 'applications#create',             as: :applications
  delete '/settings/applications/:application',   to: 'applications#destroy',            as: :application
  delete '/settings/authorizations/:application', to: 'authorized_applications#destroy', as: :authorization

  get    '/:run/edit',                      to: 'runs#edit',                      as: :edit_run
  get    '/:run/stats',                     to: 'runs/stats#index',               as: :run_stats
  get    '/:run/stats/run_history.csv',     to: 'runs/stats#run_history_csv',     as: :run_history_csv
  get    '/:run/stats/segment_history.csv', to: 'runs/stats#segment_history_csv', as: :segment_history_csv
  get    '/:run',                           to: 'runs#show',                      as: :run
  patch  '/:run',                           to: 'runs#update'
  delete '/:run',                           to: 'runs#destroy'

  namespace :api do
    namespace :webhooks do
      post '/patreon', to: 'patreon#create'
      post '/parse',   to: 'parse#create'
    end

    namespace :v4 do
      match '(/*a(/*b(/*c(/*d))))', via: [:options], to: 'application#options'

      get '/games',       to: 'games#index', as: 'games'
      get '/games/:game', to: 'games#show',  as: 'game'

      get '/games/:game/categories', to: 'games/categories#index'
      get '/games/:game/runners',    to: 'games/runners#index'
      get '/games/:game/runs',       to: 'games/runs#index'

      get '/categories/:category',         to: 'categories#show', as: 'category'
      get '/categories/:category/runners', to: 'categories/runners#index'
      get '/categories/:category/runs',    to: 'categories/runs#index'

      get '/runners',         to: 'runners#index', as: 'runners'
      get '/runners/:runner', to: 'runners#show',  as: 'runner'

      get '/runners/:runner/pbs',        to: 'runners/pbs#index'
      get '/runners/:runner/runs',       to: 'runners/runs#index'
      get '/runners/:runner/games',      to: 'runners/games#index'
      get '/runners/:runner/categories', to: 'runners/categories#index'

      post   '/runs',      to: 'runs#create'
      get    '/runs/:run', to: 'runs#show', as: 'run'
      put    '/runs/:run', to: 'runs#update'
      delete '/runs/:run', to: 'runs#destroy'

      delete '/runs/:run/user', to: 'runs/users#destroy'

      post '/convert', to: 'converts#create'

      post '/workers', to: 'workers#create'
    end

    namespace :v3 do
      match '(/*a(/*b(/*c(/*d))))', via: [:options], to: 'application#options'
      resources :games, only: %i[index show] do
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

      resources :runs, only: %i[show create destroy] do
        member do
          post :disown
        end
      end
    end
  end
end
