class User < ApplicationRecord
  has_secure_password
  has_many :bookshelves
  has_many :books, through: :bookshelves

  validates :username, presence: true, uniqueness: true
end
