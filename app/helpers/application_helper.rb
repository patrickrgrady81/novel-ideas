module ApplicationHelper
  def logged_in?
    current_user != nil
  end
  
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logout
    session[:user_id] = nil
  end

end
