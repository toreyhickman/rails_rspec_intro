class Post < ActiveRecord::Base
  attr_accessible :title, :content, :is_published

  scope :recent, order: "created_at DESC", limit: 5

  before_save :titleize_title, :create_slug

  validates_presence_of :title, :content

  private

  def titleize_title
    self.title = title.titleize
  end

  def create_slug
  	slug = self.title.downcase.split(" ")
  	slug = eliminate_non_word_characters(slug)
    self.slug = slug.join("-")
  end

  def eliminate_non_word_characters(array)
  	array.each do |element|
  	  element.gsub!(/(\W|\d)/, "")
  	end
    array
  end
end