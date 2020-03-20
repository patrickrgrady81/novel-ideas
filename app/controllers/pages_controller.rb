class PagesController < ApplicationController
  def index
  end

  def login
    @user = User.new
  end

  def logout
    # raise session.inspect
  end

  def signup
    @user = User.new
  end

  def top100
    @books = Book.all
  end
end
