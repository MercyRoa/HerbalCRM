class RemoveTypeFromLeads < ActiveRecord::Migration
  def up
    remove_column :leads, :type
    add_column :leads, :stage, :string
  end

  def down
    remove_column :leads, :stage
    add_column :leads, :type, :string
  end
end
