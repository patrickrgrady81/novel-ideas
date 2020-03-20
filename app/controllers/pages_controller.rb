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
      Book.new(info)
    end


    return Book.all
  end
end
