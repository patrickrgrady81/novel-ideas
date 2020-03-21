class UsersController < ApplicationController
  def index
  end

  def show 
    raise params.inspect
  end

  def create
    # Create the new user here
    helpers.logout
    new_user = User.create(username: params['user']['username'], email: params['user']['email'], password: params['user']['password'])
    user = User.find_by(username: new_user.username)
    session[:user_id] = user.id
    redirect_to '/profile'
  end

  def new
  end
end
