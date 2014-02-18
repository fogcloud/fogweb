Fogweb::Application.routes.draw do
  devise_for :users
  resources :users
  resources :plans

  get "main/index"
  get "main/contact"

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end
