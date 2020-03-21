class UsersController < ApplicationController
  def index
  end

  def show 
  end

  def login
    # Log the user in here
    user = User.find_by(username: params[:username])
    redirect_to '/signup' if !user
    if user.authenticate(params[:password])
      session[:user_id] = user.id 
      redirect_to '/profile'
    else 
      redirect_to '/login'
    end

  end

  def create
    # Create the new user here
    # raise params.inspect
    helpers.logout
    new_user = User.create(username: params['username'], email: params['email'], password: params['password'])
    user = User.find_by(username: new_user.username)
    session[:user_id] = user.id
    redirect_to '/profile'
  end

  def new
  end
end
