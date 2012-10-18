class AddLabelToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :label, :string
  end
end
