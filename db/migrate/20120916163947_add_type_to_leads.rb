class AddTypeToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :type, :string, {default: 'lead', null: false}
  end
end
