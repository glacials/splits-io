SplitsIO::Application.routes.draw do
  root 'runs#front'

  get '/faq', to: 'pages#faq', as: :faq
  get '/why', to: 'pages#why', as: :why

  get  '/upload',     to: 'runs#new',        as: :upload
  post '/upload',     to: 'runs#upload'
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

  get '/:run',                         to: 'runs#show',     as: :run
  get '/:run/compare/:comparison_run', to: 'runs#compare',  as: :compare
  get '/:run/download/:program',       to: 'runs#download', as: :download

  delete '/:run',      to: 'runs#delete', as: :delete
  delete '/:run/user', to: 'runs#disown', as: :disown

  get '/u/:user_name', to: 'users#show' # deprecated
  get '/users/:user_name', to: 'users#show', as: :user

  get '/games/:game_shortname', to: 'games#show', as: :game

  namespace :api do
    namespace :v1 do
      resources :games,      only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :users,      only: [:index, :show]
      resources :runs,       only: [:index, :show, :create]
    end
  end
end
