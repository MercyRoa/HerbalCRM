class AddAssignedToToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :assigned_to, :integer
  end
end
