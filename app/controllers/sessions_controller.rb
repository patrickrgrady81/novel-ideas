class SessionsController < ApplicationController
  def new
    @session = nil
  end

  # def create     
  #   auth = request.env["omniauth.auth"]     
  #   user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)     
  #   session[:user_id] = user.id     
  #   redirect_to root_url, :notice => "Signed in!"
  # end

  # For logging in users
  def create
    if params[:password]
      user = User.find_by(username: params[:username])
      redirect_to new_user_path if !user
      if user.authenticate(params[:password])
        session[:user_id] = user.id 
        redirect_to user_path(user.id)
      else 
        redirect_to new_session_path
      end
    else
      auth = request.env["omniauth.auth"]
      # raise auth.inspect
      # User.create_with_omniauth(auth)
      @user = User.find_by(username: auth['info']['nickname']) do |u|
        u.name = auth['info']['nickname']
      end
      # raise @user.inspect
      session[:user_id] = @user.id
      redirect_to user_path(@user.id)
    end
  end

  def logout
    helpers.logout
    redirect_to root_path
  end

  privte
end
