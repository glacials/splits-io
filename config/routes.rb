SplitsIo::Application.routes.draw do
  root 'runs#front'

  get  '/upload',     to: 'runs#upload',     as: :upload
  post '/upload',     to: 'runs#create'
  get  '/cant-parse', to: 'runs#cant_parse', as: :cant_parse
  get  '/random',     to: 'runs#random',     as: :random

  get '/signin/twitch'      => 'twitch#out', as: :twitch_out
  get '/signin/twitch/auth' => 'twitch#in',  as: :twitch_in

  devise_for :users
  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy'
  end

  get  '/search',       to: 'runs#search',  as: :search
  post '/search',       to: 'runs#search'
  get  '/search/:term', to: 'runs#results', as: :results

  get '/:run'                   => 'runs#show',     as: :run
  get '/:run/download/:program' => 'runs#download', as: :download
  get '/:run/delete'            => 'runs#delete',   as: :delete
  get '/:run/disown'            => 'runs#disown',   as: :disown

end
