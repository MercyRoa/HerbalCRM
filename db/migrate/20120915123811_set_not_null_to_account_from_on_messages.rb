class SetNotNullToAccountFromOnMessages < ActiveRecord::Migration
  def up
    change_column :messages, :from_account, :boolean, :null => false, :default => 0
  end

  def down
    change_column :messages, :from_account, :boolean, :null => true
  end
end
