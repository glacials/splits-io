SplitsIO::Application.routes.draw do
  root 'runs#front'

  get '/faq', to: 'pages#faq', as: :faq

  get  '/upload',     to: 'runs#new',        as: :upload
  post '/upload',     to: 'runs#upload'
  get  '/cant-parse', to: 'runs#cant_parse', as: :cant_parse
  get  '/random',     to: 'runs#random',     as: :random

  get '/signin/twitch',      to: 'twitch#out', as: :twitch_out
  get '/signin/twitch/auth', to: 'twitch#in',  as: :twitch_in

  devise_for :users
  devise_scope :user do
    get 'signout', to: 'devise/sessions#destroy', as: :signout
  end

  get  '/search',       to: 'runs#search',  as: :search
  post '/search',       to: 'runs#search'
  get  '/search/:term', to: 'runs#results', as: :results

  get '/:run',                   to: 'runs#show',     as: :run
  get '/:run/download/:program', to: 'runs#download', as: :download

  delete '/:run',        to: 'runs#delete', as: :delete
  post   '/:run/disown', to: 'runs#disown', as: :disown
end
