class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :lead_id
      t.string :type
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :timer

      t.timestamps
    end
  end
end
