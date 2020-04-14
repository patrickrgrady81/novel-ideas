class Book < ApplicationRecord
  #has_and_belongs_to_many :users
end
class Book < ApplicationRecord
  has_many :bookshelves
  has_many :users, through: :bookshelves

  scope :top_100, -> {
    books = []
    first = Book.first.id
    100.times do |i|
      bookID = first + i
      books << Book.find_by(id: bookID)
    end
    return books
  }
end