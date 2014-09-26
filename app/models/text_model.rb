class TextModel < ActiveRecord::Base
  has_and_belongs_to_many :campaigns

  scope :starred, where(:starred => true)
  scope :global, where(:global => true)

  after_save :delete_associated_campaigns, :if => Proc.new {|tm| tm.global }

  def self.categories
    # @todo chache this
    group('category').select('category')
  end

  def from_category
    TextModel.where(category: self.category)
  end

  def delete_associated_campaigns
    campaigns.clear
  end


end
