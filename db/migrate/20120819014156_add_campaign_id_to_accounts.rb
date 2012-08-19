class AddCampaignIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :campaign_id, :integer
  end
end
