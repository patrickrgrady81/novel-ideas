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

  def in_my_db?(book)
    # is the book in the current user's db?
    # binding.pry
    return false if !current_user.books.find_by(title: book.title, author: book.author)
    return true
    
  end
end
