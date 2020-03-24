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
    # find a random author from @books
    @suggestions = nil
    times = 0
    while times < @books.count && !@suggestions
      offset = rand(@books.count)
      rand_author = Book.offset(offset).first.author
      get_suggestions(rand_author)
      @suggestions = TempBook.all
      times += 1
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
    @books = []
    first = Book.first.id
    100.times do |i|
      bookID = first + i
      @books << Book.find_by(id: bookID)
    end
  end

  def description
    @books = []
    book_num = params[:book].to_i
    if book_num < 0 
      # We are looking at a temp book
      book_num = (-book_num) - 1
      @books << TempBook.all[book_num]
    else 
      # The book is in our db
      @books << Book.find_by(id: book_num)
    end
    book_info = {author: @books[0].author, title: @books[0].title}
    @desc = get_description(book_info)

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
    book_num = params[:book].to_i
    puts book_num
    if book_num < 0
      book_num = (-book_num) - 1 
      #create a new book from the temp
      temp_book = TempBook.all[book_num]
      puts temp_book.title
      book = Book.find_by(author: temp_book.author, title: temp_book.title)
    else
      book = Book.find_by(id: params[:book])
    end
    user = helpers.current_user
    # binding.pry
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

  def get_description(author:, title:)
    title_ = title.gsub(" ", "+")
    author_ = author.gsub(" ", "+")

    url = "https://www.bookdepository.com/search?searchTerm=#{author_}+#{title_}&search=Find+book"
    uri = URI.open(url)
    doc = Nokogiri::HTML(uri)
    begin
      href = doc.css('.book-item .item-img a').first['href']
    rescue
      return "Sorry, no description available"
    end

    url = "https://www.bookdepository.com#{href}"
    uri = URI.open(url)
    doc = Nokogiri::HTML(uri)
    desc = doc.css('.item-description').text

    desc = desc.gsub("Description", "").gsub("\n", " ").gsub(/[ ]{2,}/, " ").gsub("show more", "")
  end

  def get_suggestions(term)
    term_ = term.gsub(" ", "%20")
    url = "https://www.whatshouldireadnext.com/author/#{term_}"
    begin
      uri = URI.open(url)
    rescue
      return
    end
    doc = nil
    doc = Nokogiri::HTML(uri) 
    
    book_url = doc.css('.books__book-row__details__title a')[0]['href']

    url = "https://www.whatshouldireadnext.com#{book_url}"
    begin
      uri = URI.open(url)
    rescue 
      return 
    end
    doc = nil
    doc = Nokogiri::HTML(uri)
    
    book_titles = doc.css('.books__book-row__details__title a').map do |book|
      book.text
    end
    
    book_authors = doc.css('.books__book-row__details__author a').map do |book|
      book.text
    end
    
    book_img = doc.css('.books__book-row__cover img').map do |book|
      book['src']
    end
    
    TempBook.clear
    book_titles.count.times do |i|
      TempBook.new(title: book_titles[i], author: book_authors[i], img: book_img[i]) if book_authors[i] != term
    end
  end
end
