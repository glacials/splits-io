Splitsbin::Application.routes.draw do
  #devise_for :users
  get  "/upload"  => "runs#new",     as: :upload
  post "/upload"  => "runs#create",  as: :upload_post
  get  "/popular" => "runs#popular", as: :popular
  root to: "runs#front"
end
