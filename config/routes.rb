Fogweb::Application.routes.draw do

  devise_for :users, controllers: { sessions: 'sessions' }
  resources :users
  resources :plans
  resources :blocks

  get "main/index"
  get "main/contact"
  get "main/dashboard"

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end
