AdminUser.destroy_all
AdminUser.create!(email: 'pat@pat.com', password: 'patrick', password_confirmation: 'patrick') if Rails.env.development?
User.destroy_all
Book.destroy_all

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
  Book.create(info)
end

#### Faker Users
10.times do
  username = Faker::GreekPhilosophers.unique.name.downcase.gsub(' ', '_')
  email = Faker::Internet.unique.email #=> "kirsten.greenholt@corkeryfisher.info"
  password = Faker::Internet.unique.password(min_length: 8)
  User.create(username: username, email: email, password: password)
end

puts "Created #{Book.count} Books"
puts "Created #{User.count} Users"
