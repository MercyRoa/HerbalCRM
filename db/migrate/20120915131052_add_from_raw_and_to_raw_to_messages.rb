class AddFromRawAndToRawToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :from_raw, :string
    add_column :messages, :to_raw, :string
  end
end
