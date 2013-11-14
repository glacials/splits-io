Splitsdump::Application.routes.draw do
  devise_for :users
  root to: "runs#new"
end
