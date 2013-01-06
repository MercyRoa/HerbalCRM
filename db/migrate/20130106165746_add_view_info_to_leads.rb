class AddViewInfoToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :viewing_by, :integer
    add_column :leads, :last_access_time, :datetime
  end
end
