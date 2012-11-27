class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :lead_id
      t.integer :created_by
      t.integer :assigned_to
      t.datetime :due_date
      t.boolean :done, default: false
      t.text :text

      t.timestamps
    end
  end
end
