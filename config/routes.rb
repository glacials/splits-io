Rails.application.routes.draw do
  namespace :admin do
    resources :games
    resources :game_aliases
    resources :categories
    resources :speedrun_dot_com_games
    resources :speed_runs_live_games

    resources :runs
    resources :run_histories
    resources :segments
    resources :segment_histories
    resources :highlight_suggestions
    resources :rivalries

    resources :users
    resources :twitch_users
    resources :twitch_user_follows
    resources :google_users
    resources :patreon_users

    root to: 'runs#index'
  end

  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
    controllers(tokens: 'tokens', token_info: 'token_info')
  end

  root 'runs#index'

  get '/faq',       to: 'pages#faq',            as: :faq
  get '/brand',     to: 'pages#brand',          as: :brand
  get '/read-only', to: 'pages#read_only_mode', as: :read_only_mode
  get '/privacy',   to: 'pages#privacy_policy', as: :privacy_policy
  get '/partners',  to: 'pages#partners',       as: :partners

  get '/timers/:timer_id', to: 'timers#show', as: :timer

  get '/why/permalinks', to: 'why#permalinks', as: :why_permalinks
  get '/why/darkmode',   to: 'why#darkmode',   as: :why_darkmode
  get '/why/readonly',   to: 'why#readonly',   as: :why_readonly

  get '/health', to: 'health#index'

  get  '/upload',     to: 'runs#new',        as: :new_run
  get  '/cant-parse', to: 'runs#cant_parse', as: :cant_parse
  get  '/random',     to: 'runs#random',     as: :random_run
  get  '/convert',    to: redirect('/upload')

  get '/search',    to: 'search#index'
  get '/search/:q', to: redirect('/search?q=%{q}')

  get '/:run/compare/:comparison_run', to: 'runs#compare',  as: :compare

  get '/auth/splitsio/callback', to: 'sessions#in'

  get '/auth/twitch/callback', to: 'twitch_users#in'
  get '/auth/twitch/unlink',   to: 'twitch_users#unlink'

  get '/auth/google/callback', to: 'google_users#in'
  get '/auth/google/unlink',   to: 'google_users#unlink'

  get '/auth/patreon',          to: 'patreon_users#out'
  get '/auth/patreon/callback', to: 'patreon_users#in'
  get '/auth/patreon/unlink',   to: 'patreon_users#unlink'

  post   '/auth/srdc', to: 'speedrun_dot_com_users#create',  as: :speedrun_dot_com_users
  delete '/auth/srdc', to: 'speedrun_dot_com_users#destroy', as: :speedrun_dot_com_user

  get '/auth/failure', to: 'sessions#failure'

  delete '/sessions/:session', to: 'sessions#destroy', as: :session

  get '/users/:user', to: 'users#show',               as: :user
  get '/u/:user',     to: redirect('/users/%{user}'), as: :short_user

  get '/users/:user/pbs/export/panels', to: 'users/pbs/export/panels#index', as: :user_panels

  get '/users/:user/pbs/:game/:category(/*trailing_path)', to: 'users/pbs#show', as: :user_pb

  post   '/rivalries', to: 'rivalries#create', as: :rivalries
  delete '/rivalries', to: 'rivalries#destroy'

  get   '/games',            to: 'games#index'
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

  get '/races',     to: 'races#index',  as: :races
  get '/races/:id', to: 'races#show',   as: :race

  get '/tools', to: 'tools#index'

  get  '/settings',   to: 'settings#index', as: :settings
  post '/settings',   to: 'settings#update'
  delete '/settings', to: 'settings#destroy'

  post   '/settings/applications',                   to: 'applications#create',                                  as: :applications
  get    '/settings/applications/new',               to: 'applications#new',                                     as: :new_application
  get    '/settings/applications/:application',      to: redirect('/settings/applications/%{application}/edit'), as: :application
  get    '/settings/applications/:application/edit', to: 'applications#edit',                                    as: :edit_application
  patch  '/settings/applications/:application',      to: 'applications#update'
  delete '/settings/applications/:application',      to: 'applications#destroy'
  delete '/settings/authorizations/:application',    to: 'authorized_applications#destroy',                      as: :authorization

  get   '/subscriptions',         to: 'subscriptions#index',   as: :subscriptions
  get   '/subscriptions/success', to: 'subscriptions#show',    as: :subscription
  patch '/subscriptions',         to: 'subscriptions#update'
  delete '/subscriptions',        to: 'subscriptions#destroy'

  get    '/:run/edit',  to: 'runs#edit', as: :edit_run
  get    '/:run',       to: 'runs#show', as: :run, format: false # disable format so requests like /ads.txt don't render a run
  get    '/:run/stats', to: redirect('/%{run}') # to support old links floating around the internet; RIP stats page
  patch  '/:run',       to: 'runs#update'
  delete '/:run',       to: 'runs#destroy'

  put    '/:run/like', to: 'runs/likes#create',  as: :create_run_like
  delete '/:run/like', to: 'runs/likes#destroy', as: :destroy_run_like

  put '/:run/video', to: 'runs/videos#update', as: :run_video

  get '/:run/export/history.csv',         to: 'runs/exports#history_csv',         as: :history_csv
  get '/:run/export/segment_history.csv', to: 'runs/exports#segment_history_csv', as: :segment_history_csv
  get '/:run/export/:timer',              to: 'runs/exports#timer',               as: :download
  get '/:run/download/:timer',            to: 'runs/exports#timer' # deprecated

  namespace :api do
    namespace :webhooks do
      post '/patreon', to: 'patreon#create'
      post '/parse',   to: 'parse#create'
      post '/stripe',  to: 'stripe#create'
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

      get '/runner',          to: 'runners#me',    as: 'self_runner'
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

      post '/runs/:run/splits', to: 'runs/splits#create', as: 'run_split'

      get '/runs/:run/source_file', to: 'runs/source_files#show', as: 'run_source_file'
      put '/runs/:run/source_file', to: 'runs/source_files#update'

      delete '/runs/:run/user', to: 'runs/users#destroy'

      post '/convert', to: 'converts#create'

      get   '/races',     to: 'races#index',  as: 'races'
      post  '/races',     to: 'races#create'
      get   '/races/:id', to: 'races#show',   as: 'race'
      patch '/races/:id', to: 'races#update'

      get    '/races/:race_id/entries/:id', to: 'races/entries#show',   as: 'race_entry'
      post   '/races/:race_id/entries',     to: 'races/entries#create', as: 'race_entries'
      patch  '/races/:race_id/entries/:id', to: 'races/entries#update'
      delete '/races/:race_id/entries/:id', to: 'races/entries#destroy'

      post '/races/:race_id/entries/:entry_id/splits', to: 'races/entries/splits#create', as: 'race_entry_split'

      get  '/races/:race_id/chat', to: 'races/chat_messages#index',  as: 'race_chat_messages'
      post '/races/:race_id/chat', to: 'races/chat_messages#create'

      post '/races/:race_id/ghosts', to: 'races/ghosts#create'

      post '/timesync', to: 'time#create'
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
