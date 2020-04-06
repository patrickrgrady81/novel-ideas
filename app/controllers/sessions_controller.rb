class SessionsController < ApplicationController
  def new
    @session = nil
  end

  # For logging in users
  def create
    if params[:password] # User entered username and password
      user = User.find_by(username: params[:username])
      if !user
        invalid
      else
        if user.authenticate(params[:password]) # Is username and password correct?
          # yes
          session[:user_id] = user.id 
          redirect_to user_path(user.id)
        else 
          # no
          invalid
        end
      end
    else # Logging in via oauth
      auth = request.env["omniauth.auth"]
      # raise auth.inspect
      @user = User.find_by(username: auth['info']['nickname']) do |u|
        u.name = auth['info']['nickname']
      end
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    end
  end

  def logout
    logout_user
    redirect_to root_path
  end

  private

  def invalid
    @error = "Invalid user name or password"
    render 'new'
  end
end
