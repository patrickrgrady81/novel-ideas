class Book < ApplicationRecord
  #has_and_belongs_to_many :users
end
class Book < ApplicationRecord
  has_many :bookshelves
  has_many :users, through: :bookshelves
end