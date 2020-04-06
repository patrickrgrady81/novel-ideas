class ApplicationController < ActionController::Base
  layout "application"
  helper_method :logged_in?
  helper_method :current_user
  helper_method :current_username
  helper_method :logout
  helper_method :in_my_db?

  def logged_in?
    current_user != nil
  end
  
  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_username
    current_user.username
  end

  def logout_user
    session[:user_id] = nil
  end

  def in_my_db?(book)
    # is the book in the current user's db?
    # binding.pry
    return false if !current_user.books.find_by(title: book.title, author: book.author)
    return true
  end
end
