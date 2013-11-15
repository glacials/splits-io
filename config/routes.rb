Splitsdump::Application.routes.draw do
  #devise_for :users
  get  "/upload"  => "runs#upload",      as: :upload
  post "/upload"  => "runs#upload_post", as: :upload_post
  get  "/popular" => "runs#popular",     as: :popular
  root to: "runs#new"
end
