class User < ApplicationRecord
  has_secure_password
  has_many :bookshelves
  has_many :books, through: :bookshelves

  has_many :posts
  has_many :comments;
    
  # Friends
  has_many :friends, foreign_key: [:user1, :user2]
  
  has_many :friends, ->(user) { unscope(:where).where("accepted = true AND user1 = :id OR user2 = :id", id: user.id) }
  has_many :pending_friends, ->(user) { unscope(:where).where("accepted = false AND user1 = :id", id: user.id) }
  has_many :pending_requests, ->(user) { unscope(:where).where("accepted = false AND user2 = :id", id: user.id) }
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true


  def friend_request(user)
    f = Friend.create(user1: self, user2: user)
    user.friends << f
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

end
