class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.integer :campaign_id
      t.integer :account_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :status
      t.integer :raiting
      t.string :phone
      t.string :country
      t.string :city
      t.string :address
      t.string :source
      t.datetime :last_contacted
      t.integer :step
      t.boolean :automatic
      t.integer :messages_received_count
      t.integer :messages_sent_count

      t.timestamps
    end
  end
end
