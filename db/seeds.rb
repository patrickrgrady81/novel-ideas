AdminUser.destroy_all
AdminUser.create!(email: 'pat@pat.com', password: 'patrick', password_confirmation: 'patrick') if Rails.env.development?
Book.destroy_all
User.destroy_all

#scrape for top 100 books
book_url = 'https://www.goodreads.com/list/tag/best'
open_doc = URI.open(book_url).read
doc = Nokogiri::HTML(open_doc)
best_books = doc.at_css('.cell .listImgs a').attribute('href')

best_books_url = "#{book_url[0..-15]}#{best_books}"
open_doc = URI.open(best_books_url).read
doc = Nokogiri::HTML(open_doc)
book_titles = doc.css('.bookTitle > span').collect do |book|
   book.content
end
book_authors = doc.css('.authorName > span').collect do |author|
  author.content
end
book_covers = doc.css('.bookCover').collect do |cover|
  cover.attribute('src')
end
100.times do |i|
  info = {title: book_titles[i], author: book_authors[i], img: book_covers[i]}
  b = Book.create(info)
end
start = Book.all.first.id
end_num = start + 99

### Faker Users
10.times do
  username = Faker::GreekPhilosophers.unique.name.downcase.gsub(' ', '_')
  email = Faker::Internet.unique.email
  password = "password"
  u = User.create(username: username, email: email, password: password)
  5.times do 
    r = rand(start..end_num)
    u.books << Book.find_by(id: r)
  end
end
User.create(username: "pat", email: "pat", password: "pat")


puts "Created #{Book.count} Books"
puts "Created #{User.count} Users"
