class AddDraftToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :draft, :text
  end
end
