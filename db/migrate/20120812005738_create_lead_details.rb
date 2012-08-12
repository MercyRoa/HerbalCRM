class CreateLeadDetails < ActiveRecord::Migration
  def change
    create_table :lead_details do |t|
      t.integer :lead_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
