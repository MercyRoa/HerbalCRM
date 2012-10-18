class RemoveCampaignIdFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :campaign_id
    remove_column :accounts, :label
  end

  def down
    add_column :accounts, :label, :string
    add_column :accounts, :campaign_id, :integer
  end
end
