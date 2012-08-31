class AddDateToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :date, :datetime
  end
end
