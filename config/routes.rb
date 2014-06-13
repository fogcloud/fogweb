Fogweb::Application.routes.draw do

  resources :shares

  get 'users/sign_up' => redirect('/404.html')
  post 'users/create' => redirect('/404.html')

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users
  resources :plans

  get  "blocks/upload_form"
  post "blocks/upload"
  get  "blocks/download_form"
  post "blocks/download"
  resources :blocks

  get "main/index"
  get "main/contact"
  get "main/dashboard"
  get "main/admin"

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end
