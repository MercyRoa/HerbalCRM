class AccountsCampaigns < ActiveRecord::Migration
  def up
    create_table :accounts_campaigns, :id => false do |t|
      t.references :account, :null => false
      t.references :campaign, :null => false
    end

    # Adding the index can massively speed up join tables. Don't use the
    # unique if you allow duplicates.
    add_index(:accounts_campaigns, [:account_id, :campaign_id], :unique => true)
  end

  def down
    drop_table :accounts_campaigns
  end
end
