class AddUserIdToScheduledMessages < ActiveRecord::Migration
  def change
    add_column :scheduled_messages, :user_id, :integer
  end
end
