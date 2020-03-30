class SessionsController < ApplicationController
  def new
    @session = nil
  end

  # For logging in users
  def create
    user = User.find_by(username: params[:username])
    redirect_to new_user_path if !user
    if user.authenticate(params[:password])
      session[:user_id] = user.id 
      redirect_to user_path(user.id)
    else 
      redirect_to new_session_path
    end
  end

  def logout
    helpers.logout
    redirect_to root_path
  end
end
