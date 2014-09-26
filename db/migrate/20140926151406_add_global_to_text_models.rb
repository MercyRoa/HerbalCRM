class AddGlobalToTextModels < ActiveRecord::Migration
  def change
    add_column :text_models, :global, :boolean
  end
end
