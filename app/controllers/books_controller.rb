class BooksController < ApplicationController

  def index
    if params[:search]
      @books = Book.search(params[:search])
    else
      @books = Book.all
    end
  end


  def top100
    @books = Book.top100
    render :index
  end

end
