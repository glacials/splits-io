Splitsdump::Application.routes.draw do
  #devise_for :users
  get "/upload"  => "runs#upload",  as: :upload
  get "/popular" => "runs#popular", as: :popular
  root to: "runs#new"
end
