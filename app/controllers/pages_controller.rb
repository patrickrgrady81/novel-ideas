class PagesController < ActionController::Base
  def index
  end

  def login
  end

  def signup
    @user = User.new
  end
end
