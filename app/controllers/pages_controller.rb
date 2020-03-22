require 'open-uri'

class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js, :json, :html
  def index
  end

  def profile
    if !helpers.logged_in?
      redirect_to '/'
    else
      @books =  helpers.current_user.books.all
    end
  end

  def login
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

  def add
    puts params
    book_num = params[:book].to_i
    puts book_num
    if book_num < 0
      book_num = (-book_num) - 1 
      #create a new book from the temp
      temp_book = TempBook.all[book_num]
      puts temp_book.title
      book = Book.create_or_find_by(title: temp_book.title, author: temp_book.author, img: temp_book.img)
      puts book
    else
      # find the book
      bookID = params[:book]
      book = Book.find_by(id: bookID)
      puts book
    end
    user = helpers.current_user
    user.books << book 
    redirect_to '/profile'
  end

  def remove
    # puts params[:book]
    user = helpers.current_user
    book = Book.find_by(params[:book])
    user.books.delete(book)
    redirect_to '/profile'
  end

  def results
    TempBook.clear
    @books = search_for(params[:search])
  end

  def search_for(term)
    # term = 'Stephen King'
    url = "https://www.goodreads.com/search?utf8=%E2%9C%93&q=#{term}&search_type=books"
    uri = URI.open(url)
    doc = Nokogiri::HTML(uri)
    book_titles = doc.css('.bookTitle span').collect do |title|
      title.text
    end
    book_authors = doc.css('.authorName span').collect do |author|
      author.text
    end
    book_urls = doc.css('.bookCover').collect do |ur|
      ur.attribute('src')
    end

    book_titles.count.times do |i|
      title = book_titles[i]
      author = book_authors[i]
      img = book_urls[i]
      info = {title: title, author: author, img: img}
      TempBook.new(info)
    end


    return TempBook.all
  end
end
