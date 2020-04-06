Rails.application.routes.draw do

  root to: 'pages#index'

  get '/logout', to: 'sessions#logout'

  get '/top100', to: 'books#top100', as: 'top100'

  post '/results', to: 'books#index', as: 'search_results' 
  post '/add', to: 'books#add', as: 'add_book'
  post '/remove', to: 'books#remove', as: 'remove_book'

  resources :users, only: [:index, :show, :new, :create]
  resources :posts
  resources :sessions, only: [:new, :create]
  resources :books, only: [:index, :show]

  get "/auth/:provider/callback", to: "sessions#create"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
