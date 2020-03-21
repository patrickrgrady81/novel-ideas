Rails.application.routes.draw do
  get '/', to: 'pages#index'
  get '/login', to: 'pages#login'
  get '/signup', to: 'pages#signup'
  get '/logout', to: 'pages#logout'
  get '/top100', to: 'pages#top100'
  post '/results', to: 'pages#results'
  get '/results', to: 'pages#index'
  get '/profile/', to: 'pages#profile'

  resources :users

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
