class AddValidToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :valid, :boolean
  end
end
