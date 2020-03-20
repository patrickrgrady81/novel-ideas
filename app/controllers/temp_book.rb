class TempBook
  attr_accessor :title, :author, :img

  @@all = []

  def initialize(title:, author:, img:)
    @title = title
    @author = author
    @img = img
    @@all << self
  end

  def self.all
    @@all
  end

  def self.clear
    @@all = []
  end
end