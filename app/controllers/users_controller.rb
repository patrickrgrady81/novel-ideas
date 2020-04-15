class UsersController < ApplicationController
  def index
  end

  def show 
    if logged_in?
        if current_user.id == params[:id].to_i
        @books = current_user.books.all

        @suggestions = nil
        times = 0
        while times < @books.count && !@suggestions
          offset = rand(@books.count)
          rand_author = Book.offset(offset).first.author
          # get_suggestions(rand_author)
          @suggestions = quick_suggest #TempBook.all
          times += 1
        end
        else
          redirect_to "/users/#{current_user.id}"
      end
    else
      redirect_to root_path
    end
  end

  def create
    # Create the new user here
    logout_user
    check = User.find_by(username: params[:username]) || User.find_by(email: params[:email])
    if check
      @error = "User name or email taken"
      render "new"

    else
      new_user = User.create(username: params['username'], email: params['email'], password: params['password'][0])
      user = User.find_by(username: new_user.username)
      session[:user_id] = user.id
      redirect_to user_path(user.id)
    end
  end

  def new
    @user = User.new
  end

  private 

  def quick_suggest()
    Book.limit(15).order("random()")
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
