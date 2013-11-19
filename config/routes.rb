Splitsbin::Application.routes.draw do
  #devise_for :users
  get  "/upload"  => "runs#new",     as: :upload
  post "/upload"  => "runs#create"
  get  "/popular" => "runs#popular", as: :popular
  root to: "runs#front"

  get "/:nick"          => "runs#show",     as: :run
  get "/:nick/download" => "runs#download", as: :download_run
end
