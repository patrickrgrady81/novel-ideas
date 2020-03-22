class TempBook
  attr_accessor :title, :author, :img, :id

  @@all = []
  @@total = -1

  def initialize(title:, author:, img:)
    @title = title
    @author = author
    @img = img
    @id = @@total
    @@total -= 1
    @@all << self
  end

  def self.all
    @@all
  end

  def self.clear
    @@all = []
    @@total = -1
  end
end