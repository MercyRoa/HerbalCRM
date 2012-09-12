class ChangeMessageIdToString < ActiveRecord::Migration
  def up
    change_column :messages, :message_id, :string
  end

  def down
    change_column :messages, :message_id, :integer
  end
end
