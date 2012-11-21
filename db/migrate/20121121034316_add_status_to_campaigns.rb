class AddStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :status, :boolean, {default: true, null: false}
  end
end
