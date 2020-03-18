class PagesController < ActionController::Base
  def index
  end

  def login
    @user = User.new
  end

  def signup
    @user = User.new
  end
end
