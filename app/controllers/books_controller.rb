require 'open-uri'
class BooksController < ApplicationController

  def index
    if params[:search]
      TempBook.clear
      search_for(params[:search])
      @books = TempBook.all
      render 'results'
    end
  end

  def show 
    @books = []
    book_num = params[:id].to_i
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

  def top100
    @books = []
    first = Book.first.id
    100.times do |i|
      bookID = first + i
      @books << Book.find_by(id: bookID)
    end
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
    user = current_user
    user.books << book 
    redirect_to user_path(user.id)
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
    user = current_user
    # binding.pry
    user.books.delete(book)
    redirect_to user_path(user.id)
  end

  private

  def search_for(term)
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
end