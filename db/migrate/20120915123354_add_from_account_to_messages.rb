class AddFromAccountToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :from_account, :boolean
  end
end
