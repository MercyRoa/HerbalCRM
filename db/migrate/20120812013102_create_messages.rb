class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :account_id
      t.integer :lead_id
      t.string :from
      t.string :to
      t.text :headers
      t.text :body
      t.text :body_raw
      t.boolean :readed

      t.timestamps
    end
  end
end
