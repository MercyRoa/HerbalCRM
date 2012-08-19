class AddLabelToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :label, :string
  end
end
