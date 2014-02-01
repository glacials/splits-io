SplitsIo::Application.routes.draw do
  #devise_for :users
  get  '/upload'     => 'runs#upload',     as: :upload
  post '/upload'     => 'runs#create'
  get  '/cant-parse' => 'runs#cant_parse', as: :cant_parse
  get  '/random'     => 'runs#random',     as: :random

  get '/:nick'                  => 'runs#show',              as: :run
  get '/:nick/download'         => 'runs#download_original', as: :download_original_run
  get '/:nick/download/:format' => 'runs#download',          as: :download_run

  root to: 'runs#front'
end
