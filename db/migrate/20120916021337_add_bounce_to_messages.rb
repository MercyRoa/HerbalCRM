class AddBounceToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :bounce, :integer
  end
end
