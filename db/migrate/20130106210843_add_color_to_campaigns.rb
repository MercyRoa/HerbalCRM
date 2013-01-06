class AddColorToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :color, :string
  end
end
