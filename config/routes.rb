Fogweb::Application.routes.draw do
  get 'users/sign_up' => redirect('/404.html')
  post 'users/create' => redirect('/404.html')

  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users
  resources :plans

  get  "shares/:name/get/:block", to: "shares#get_block"
  post "shares/:name/put/:block", to: "shares#put_block"
  post "shares/:name/remove", to: "shares#remove_blocks"

  resources :shares, param: :name, only: [:index, :show, :create, :update, :destroy]

  get "main/index"
  get "main/contact"
  get "main/dashboard"
  get "main/admin"

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
end
