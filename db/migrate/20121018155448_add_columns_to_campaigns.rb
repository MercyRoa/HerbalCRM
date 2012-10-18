class AddColumnsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :search_query, :string, {default: 'is:unread'}
    add_column :campaigns, :last_fetch_date, :datetime
  end
end
