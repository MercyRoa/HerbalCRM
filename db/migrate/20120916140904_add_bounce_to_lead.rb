class AddBounceToLead < ActiveRecord::Migration
  def change
    add_column :leads, :bounce, :integer
    remove_column :messages, :bounce
  end
end
