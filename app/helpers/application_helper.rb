module ApplicationHelper
  def logged_in?
    session[:user_id] != nil
  end
  
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logout
    debug session
    session[:user_id] = nil
  end

end
