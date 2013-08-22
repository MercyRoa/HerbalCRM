class AddStarredToTextModels < ActiveRecord::Migration
  def change
    add_column :text_models, :starred, :boolean
  end
end
