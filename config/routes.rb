SplitsIo::Application.routes.draw do
  #devise_for :users
  get  "/upload"          => "runs#new",             as: :upload
  get  "/upload/fallback" => "runs#upload_fallback", as: :fallback_upload
  post "/upload"          => "runs#create"
  get  "/cant-parse"      => "runs#cant_parse",      as: :cant_parse
  get  "/random"          => "runs#random",          as: :random
  root to: "runs#front"

  get "/:nick"                  => "runs#show",     as: :run
  #get "/:nick/download"         => "runs#download", as: :download_run
  get "/:nick/download/:format" => "runs#download", as: :download_run
end
