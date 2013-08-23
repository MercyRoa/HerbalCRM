class TextModel < ActiveRecord::Base

  scope :starred, where(:starred => true)

  def self.categories
    # @todo chache this
    group('category').select('category')
  end

  def from_category
    TextModel.where(category: self.category)
  end
end
