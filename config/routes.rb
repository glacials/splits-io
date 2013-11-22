SplitsIo::Application.routes.draw do
  #devise_for :users
  get  "/upload"     => "runs#new",        as: :upload
  post "/upload"     => "runs#create"
  get  "/popular"    => "runs#popular",    as: :popular
  get  "/cant-parse" => "runs#cant_parse", as: :cant_parse
  get  "/random"     => "runs#random",     as: :random
  root to: "runs#front"

  get "/:nick"          => "runs#show",     as: :run
  get "/:nick/download" => "runs#download", as: :download_run
end
