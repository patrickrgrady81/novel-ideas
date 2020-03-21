require 'open-uri'

class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token
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

  def results
    TempBook.clear
    @results = search_for(params[:search])
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
