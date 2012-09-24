class RemoveValidFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :valid
    add_column :messages, :countable, :boolean
  end

  def down
    remove_column :messages, :countable
    add_column :messages, :valid, :boolean
  end
end
