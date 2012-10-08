class AddMessageIdToScheduledMessages < ActiveRecord::Migration
  def change
    add_column :scheduled_messages, :message_id, :string
  end
end
