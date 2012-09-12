class AddLastFetchDateToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :last_fetch_date, :datetime
  end
end
