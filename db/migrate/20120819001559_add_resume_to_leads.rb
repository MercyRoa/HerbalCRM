class AddResumeToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :resume, :text
  end
end
