Rails.application.routes.draw do
  get '/', to: 'page#index'
  get '/login', to: 'page#login'
  get '/signup', to: 'page#signup'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
