Fogweb::Application.routes.draw do
  get 'users/sign_up' => redirect('/404.html')
  post 'users/create' => redirect('/404.html')

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users
  resources :plans

  post "shares/:name/check",  to: "shares#check_blocks"
  post "shares/:name/get",    to: "shares#get_blocks"
  post "shares/:name/put",    to: "shares#put_blocks"
  post "shares/:name/remove", to: "shares#remove_blocks"

  resources :shares, param: :name, only: [:index, :show, :create, :update, :destroy]

  get "main/index"
  get "main/contact"
  get "main/dashboard"
  get "main/admin"
  get "main/auth"

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end
