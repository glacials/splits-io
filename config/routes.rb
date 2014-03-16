SplitsIo::Application.routes.draw do
  #devise_for :users
  get  '/upload'     => 'runs#upload',     as: :upload
  post '/upload'     => 'runs#create'
  get  '/cant-parse' => 'runs#cant_parse', as: :cant_parse
  get  '/random'     => 'runs#random',     as: :random

  get '/login/twitch'      => 'twitch#out', as: :twitch_out
  get '/login/twitch/auth' => 'twitch#in',  as: :twitch_in

  devise_for :users
  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy'
  end

  get '/:nick'                  => 'runs#show',              as: :run
  get '/:nick/download'         => 'runs#download_original', as: :download_original
  get '/:nick/download/:format' => 'runs#download',          as: :download
  get '/:nick/delete'           => 'runs#delete',            as: :delete
  get '/:nick/disown'           => 'runs#disown',            as: :disown

  root to: 'runs#front'
end
