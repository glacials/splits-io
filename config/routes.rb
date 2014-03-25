SplitsIo::Application.routes.draw do
  #devise_for :users
  get  '/upload'     => 'runs#upload',     as: :upload
  post '/upload'     => 'runs#create'
  get  '/cant-parse' => 'runs#cant_parse', as: :cant_parse
  get  '/random'     => 'runs#random',     as: :random

  get '/signin/twitch'      => 'twitch#out', as: :twitch_out
  get '/signin/twitch/auth' => 'twitch#in',  as: :twitch_in

  devise_for :users
  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy'
  end

  get '/:run'                  => 'runs#show',     as: :run
  get '/:run/download/:format' => 'runs#download', as: :download
  get '/:run/delete'           => 'runs#delete',   as: :delete
  get '/:run/disown'           => 'runs#disown',   as: :disown

  root to: 'runs#front'
end
