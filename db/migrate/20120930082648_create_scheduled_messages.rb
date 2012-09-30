class CreateScheduledMessages < ActiveRecord::Migration
  def change
    create_table :scheduled_messages do |t|
      t.integer :account_id
      t.integer :lead_id
      t.string :to
      t.string :cc
      t.string :bcc
      t.string :subject
      t.text :body
      t.text :body_html
      t.datetime :scheduled
      t.boolean :sent, default: false

      t.timestamps
    end
  end
end
