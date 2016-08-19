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

  resources :games, id: /[^\/]+/, only: [:index, :show, :edit] do
    resources :categories, only: [:show], module: :games do
      resources :leaderboards, only: [], module: :categories do
        collection do
          resources :sum_of_bests, only: [:index], module: :leaderboards
        end
      end
    end
    resources :aliases, only: [:create], module: :games
  end

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
      resources :categories, only: [:show] do
        resources :runners, :runs, only: :index, module: :categories
      end

      resources :games, only: [:index, :show] do
        resources :categories, :runners, :runs, only: :index, module: :games
      end

      resources :runners, only: [:show] do
        resources :categories, :games, :pbs, :predictions, :runs, only: :index, module: :runners
      end

      resources :runs, only: [:create, :show, :update, :destroy] do
        resources :splits, only: :index, module: :runs
      end

      post '/convert',    to: 'converts#create',  as: :api_convert
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
